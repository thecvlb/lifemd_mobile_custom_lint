import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:custom_lint_core/custom_lint_core.dart' as clc show LintCode;

class AvoidPrintAndGetLog extends DartLintRule {
  AvoidPrintAndGetLog() : super(code: _code);

  static const _codeName = 'avoid-print-and-get-log';
  static const _description =
      'Should use `Talker` instead of `debugPrint` and `Get.log`';

  static const _code =
      const clc.LintCode(name: _codeName, problemMessage: _description);

  String _getDescription(method) => 'Should use `Talker` instead of `$method`';

  @override
  Future<void> run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) async {
    context.registry.addMethodInvocation((node) {
      if (node.methodName.name == 'debugPrint') {
        reporter.atNode(
          node,
          clc.LintCode(
              name: _codeName, problemMessage: _getDescription('debugPrint')),
        );
      }
      if (node.methodName.name == 'log' && node.target.toString() == 'Get') {
        reporter.atNode(
          node,
          clc.LintCode(
              name: _codeName, problemMessage: _getDescription('Get.log')),
        );
      }
    });
  }
}
