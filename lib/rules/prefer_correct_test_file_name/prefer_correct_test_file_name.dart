import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:custom_lint_core/custom_lint_core.dart' as clc show LintCode;

class PreferCorrectTestFileName extends DartLintRule {
  PreferCorrectTestFileName() : super(code: _code);

  static const _code = const clc.LintCode(
    name: 'prefer-correct-test-file-name',
    problemMessage: 'Test file must ends with _test',
    errorSeverity: ErrorSeverity.WARNING,
  );

  List<String> get filesToAnalyze => const ['test/**.dart'];

  @override
  Future<void> run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) async {
    if (!resolver.source.shortName.endsWith('_test.dart')) {
      context.registry.addFunctionDeclaration((node) {
        final name = node.name.lexeme;
        final isEntryPoint = name == 'main';
        if (isEntryPoint) {
          reporter.reportErrorForNode(code, node);
        }
      });
    }
  }
}
