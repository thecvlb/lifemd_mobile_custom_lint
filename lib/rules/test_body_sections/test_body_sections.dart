import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:quiver/collection.dart';

class TestBodySections extends DartLintRule {
  TestBodySections() : super(code: _code);

  static const _codeName = 'test-body-sections';
  static const _code = const LintCode(
      name: _codeName, problemMessage: 'Wrong test body sections');

  static const _givenSectionName = 'Given';
  static const _whenSectionName = 'When';
  static const _thenSectionName = 'Then';

  List<String> get filesToAnalyze => const ['test/**.dart'];

  @override
  Future<void> run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) async {
    context.registry.addMethodInvocation((node) {
      final name = node.methodName.name;
      final isTest = name == 'test';
      if (isTest) {
        final functionBodyVisitor = _BlockFunctionBodyVisitor();
        node.visitChildren(functionBodyVisitor);
        final body = functionBodyVisitor.methods.firstOrNull;

        if (body == null) {
          return;
        }

        final commentVisitor = _CommentVisitor();
        commentVisitor.visitComments(body);
        final comments = commentVisitor.comments;

        final description = node.argumentList.arguments.first.toString();
        final givenDescriptionPosition =
            description.indexOf("$_givenSectionName:");
        final isGivenDescriptionExists = givenDescriptionPosition >= 0;

        final whenDescriptionPosition =
            description.indexOf("$_whenSectionName:");
        final isWhenDescriptionExists = whenDescriptionPosition >= 0;

        final thenDescriptionPosition = description.indexOf(_thenSectionName);
        final isThenDescriptionExists = thenDescriptionPosition >= 0;

        final givenBodyCount = comments
            .where((element) => element == '// $_givenSectionName')
            .length;

        final whenBodyCount = comments
            .where((element) => element == '// $_whenSectionName')
            .length;

        final thenBodyCount = comments
            .where((element) => element == '// $_thenSectionName')
            .length;

        if (isGivenDescriptionExists && givenBodyCount == 0) {
          _reportErrorForNode(reporter, body,
              'Test description contains `Given` section but body does not');
        }

        if (isWhenDescriptionExists && whenBodyCount == 0) {
          _reportErrorForNode(reporter, body,
              'Test description contains `When` section but body does not');
        }

        if (isThenDescriptionExists && thenBodyCount == 0) {
          _reportErrorForNode(reporter, body,
              'Test description contains `Then` section but body does not');
        }

        if (givenBodyCount > 1) {
          _reportErrorForNode(
              reporter, body, 'Test body should have only one `Given` section');
        }

        if (whenBodyCount > 1) {
          _reportErrorForNode(
              reporter, body, 'Test body should have only one `When` section');
        }

        if (thenBodyCount > 1) {
          _reportErrorForNode(
              reporter, body, 'Test body should have only one `Then` section');
        }

        final descriptionSections = _getSections(
          givenPosition: givenDescriptionPosition,
          whenPosition: whenDescriptionPosition,
          thenPosition: thenDescriptionPosition,
        );

        final bodySections = _getSections(
          givenPosition: comments
              .indexWhere((element) => element == '// $_givenSectionName'),
          whenPosition: comments
              .indexWhere((element) => element == '// $_whenSectionName'),
          thenPosition: comments
              .indexWhere((element) => element == '// $_thenSectionName'),
        );

        if (!listsEqual(descriptionSections, bodySections)) {
          _reportErrorForNode(reporter, body,
              'Test description and body should have the same sections order');
        }
      }
    });
  }

  List<_Section> _getSections(
      {int givenPosition = -1, int whenPosition = -1, int thenPosition = -1}) {
    final map = {
      _Section.given: givenPosition,
      _Section.when: whenPosition,
      _Section.then: thenPosition,
    };
    map.removeWhere((key, value) => value < 0);

    final elements = map.entries.toList();
    elements.sort((e1, e2) => e1.value.compareTo(e2.value));

    return elements.map((e) => e.key).toList();
  }

  void _reportErrorForNode(
    ErrorReporter reporter,
    AstNode node,
    String message,
  ) =>
      reporter.reportErrorForNode(
        LintCode(
          name: _codeName,
          problemMessage: 'Wrong test body: $message',
        ),
        node,
      );
}

class _BlockFunctionBodyVisitor extends RecursiveAstVisitor<void> {
  final methods = <BlockFunctionBody>{};

  @override
  void visitBlockFunctionBody(BlockFunctionBody node) {
    super.visitBlockFunctionBody(node);

    methods.add(node);
  }
}

class _CommentVisitor {
  List<String> comments = [];

  void visitComments(AstNode node) {
    Token? token = node.beginToken;
    while (token != null) {
      final extractedComments = <Token>[];

      Token? commentToken = token.precedingComments;
      while (commentToken != null) {
        if (_isRegularComment(commentToken)) {
          extractedComments.add(commentToken);
        }
        commentToken = commentToken.next;
      }

      // Test section name should be single line comment
      if (extractedComments.length == 1) {
        comments.add(extractedComments.first.lexeme);
      }

      if (token == token.next || token == node.endToken) {
        break;
      }

      token = token.next;
    }
  }

  bool _isRegularComment(Token commentToken) {
    final token = commentToken.toString();

    return !token.startsWith('///') && token.startsWith('//');
  }
}

enum _Section { given, when, then }
