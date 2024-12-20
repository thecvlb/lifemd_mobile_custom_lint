import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:custom_lint_core/custom_lint_core.dart' as clc show LintCode;

class AvoidTopLevelMembersInTests extends DartLintRule {
  AvoidTopLevelMembersInTests() : super(code: _code);

  static const _code = const clc.LintCode(
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
        reporter.atNode(node, code);
      }
    });

    context.registry.addMixinDeclaration((node) {
      if (!Identifier.isPrivateName(node.name.lexeme)) {
        reporter.atNode(node, code);
      }
    });

    context.registry.addExtensionDeclaration((node) {
      final name = node.name?.lexeme;
      if (name != null && !Identifier.isPrivateName(name)) {
        reporter.atNode(node, code);
      }
    });

    context.registry.addEnumDeclaration((node) {
      if (!Identifier.isPrivateName(node.name.lexeme)) {
        reporter.atNode(node, code);
      }
    });

    context.registry.addTypeAlias((node) {
      if (!Identifier.isPrivateName(node.name.lexeme)) {
        reporter.atNode(node, code);
      }
    });

    context.registry.addTopLevelVariableDeclaration((node) {
      final variables = node.variables.variables;

      if (variables.isNotEmpty &&
          !Identifier.isPrivateName(variables.first.name.lexeme)) {
        reporter.atNode(node, code);
      }
    });

    context.registry.addFunctionDeclaration((node) {
      final name = node.name.lexeme;
      final isEntryPoint = name == 'main';

      final isTop = node.parent == null || node.parent?.offset == 0;

      if (!isEntryPoint && !Identifier.isPrivateName(name) && isTop) {
        reporter.atNode(node, code);
      }
    });
  }
}
