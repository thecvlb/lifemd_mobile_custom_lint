import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class TestBodyVerifyMethods extends DartLintRule {
  TestBodyVerifyMethods() : super(code: _code);

  static const _codeName = 'test-body-verify-methods';
  static const _code = const LintCode(
      name: _codeName,
      problemMessage:
          '`Then` section should not contain more than one verify method');

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

        if (body.parent?.parent?.parent != node) {
          return;
        }

        final commentVisitor = _CommentVisitor();
        commentVisitor.visitComments(body);
        final thenNode = commentVisitor.thenToken;
        if (thenNode == null) {
          return;
        }

        final functionInvocationVisitor =
            _FunctionExpressionInvocationVisitor();
        node.visitChildren(functionInvocationVisitor);

        final verifyMethods = functionInvocationVisitor.methods.where(
            (element) =>
                (element.function.toString() == 'verify' ||
                    element.function.toString() == 'verifyInOrder') &&
                element.offset >= thenNode.offset);

        if (verifyMethods.length > 1) {
          for (final node in verifyMethods) {
            reporter.reportErrorForOffset(
              _code,
              node.offset,
              node.function.length,
            );
          }
        }
      }
    });
  }
}

class _FunctionExpressionInvocationVisitor extends RecursiveAstVisitor<void> {
  final methods = <FunctionExpressionInvocation>[];

  @override
  void visitFunctionExpressionInvocation(FunctionExpressionInvocation node) {
    super.visitFunctionExpressionInvocation(node);

    methods.add(node);
  }
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
  Token? thenToken;

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
      if (extractedComments.isNotEmpty &&
          extractedComments.first.lexeme == '// Then') {
        thenToken = token;
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
