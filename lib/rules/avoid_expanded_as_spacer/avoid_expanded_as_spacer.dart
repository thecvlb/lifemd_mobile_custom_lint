import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:custom_lint_core/custom_lint_core.dart' as clc show LintCode;

class AvoidExpandedAsSpacer extends DartLintRule {
  AvoidExpandedAsSpacer() : super(code: _code);

  static const _expandedClassName = 'Expanded';
  static const _containerClassName = 'Container';
  static const _sizedBoxClassName = 'SizedBox';

  static const _code = const clc.LintCode(
    name: 'avoid-expanded-as-spacer',
    problemMessage: 'Prefer using Spacer widget instead of Expanded.',
    correctionMessage: 'Replace with Spacer widget.',
    errorSeverity: ErrorSeverity.INFO,
  );

  @override
  Future<void> run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) async {
    context.registry.addInstanceCreationExpression((node) {
      final arguments = node.argumentList.arguments;
      final isExpanded = node.staticType?.getDisplayString(
            withNullability: true,
          ) ==
          _expandedClassName;

      final hasOneArgument = arguments.length == 1;

      if (isExpanded && hasOneArgument) {
        final expandedChild = arguments.first as NamedExpression;

        final childName = expandedChild.staticType?.getDisplayString(
          withNullability: true,
        );

        final child = expandedChild.expression;
        if (child is InstanceCreationExpression) {
          final hasNoArgument = child.argumentList.arguments.isEmpty;

          if (hasNoArgument &&
              (childName == _containerClassName ||
                  childName == _sizedBoxClassName)) {
            reporter.reportErrorForNode(code, node);
          }
        }
      }
    });
  }
}
