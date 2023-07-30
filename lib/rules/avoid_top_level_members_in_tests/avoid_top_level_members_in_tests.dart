import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class AvoidTopLevelMembersInTests extends DartLintRule {
  AvoidTopLevelMembersInTests() : super(code: _code);

  static const _code = const LintCode(
    name: 'avoid-top-level-members-in-tests',
    problemMessage: 'Avoid declaring top-level members in tests.',
    errorSeverity: ErrorSeverity.WARNING,
  );

  List<String> get filesToAnalyze => const ['test/**.dart'];

  @override
  Future<void> run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) async {
    context.registry.addClassDeclaration((node) {
      if (!Identifier.isPrivateName(node.name.lexeme)) {
        reporter.reportErrorForNode(code, node);
      }
    });

    context.registry.addMixinDeclaration((node) {
      if (!Identifier.isPrivateName(node.name.lexeme)) {
        reporter.reportErrorForNode(code, node);
      }
    });

    context.registry.addExtensionDeclaration((node) {
      final name = node.name?.lexeme;
      if (name != null && !Identifier.isPrivateName(name)) {
        reporter.reportErrorForNode(code, node);
      }
    });

    context.registry.addEnumDeclaration((node) {
      if (!Identifier.isPrivateName(node.name.lexeme)) {
        reporter.reportErrorForNode(code, node);
      }
    });

    context.registry.addTypeAlias((node) {
      if (!Identifier.isPrivateName(node.name.lexeme)) {
        reporter.reportErrorForNode(code, node);
      }
    });

    context.registry.addVariableDeclaration((node) {
      if (!Identifier.isPrivateName(node.name.lexeme)) {
        reporter.reportErrorForNode(code, node);
      }
    });

    context.registry.addFunctionDeclaration((node) {
      final name = node.name.lexeme;
      final isEntryPoint = name == 'main';

      if (!isEntryPoint && !Identifier.isPrivateName(name)) {
        reporter.reportErrorForNode(code, node);
      }
    });
  }
}
