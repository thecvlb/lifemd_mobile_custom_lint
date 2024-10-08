import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:custom_lint_core/custom_lint_core.dart' as clc show LintCode;

class PreferCorrectFileName extends DartLintRule {
  PreferCorrectFileName() : super(code: _code);

  static const _code = const clc.LintCode(
    name: 'prefer-correct-file-name',
    problemMessage: 'File must be in snake case',
    errorSeverity: ErrorSeverity.WARNING,
  );

  final _regExp = RegExp(r'^[a-z][a-z0-9]+(_[a-z0-9]+)*.dart$');

  @override
  Future<void> run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) async {
    if (!_regExp.hasMatch(resolver.source.shortName)) {
      context.registry.addClassDeclaration((node) {
        reporter.atNode(node, code);
      });
    }
  }
}
