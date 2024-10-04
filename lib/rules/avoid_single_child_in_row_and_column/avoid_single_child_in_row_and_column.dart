import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:custom_lint_core/custom_lint_core.dart' as clc show LintCode;
import 'package:lifemd_mobile_custom_lint/extensions/iterable_extensions.dart';

enum _WidgetType {
  column('Column'),
  row('Row'),
  stack('Stack');

  final String name;

  const _WidgetType(this.name);

  static _WidgetType? fromString(String? value) {
    if (value == null) return null;
    return _WidgetType.values.firstWhereOrNull(
      (it) => it.name == value,
    );
  }
}

class AvoidSingleChildInRowAndColumn extends DartLintRule {
  AvoidSingleChildInRowAndColumn() : super(code: _code);

  static const _codeName = 'avoid-single-child-in-row-and-column';

  static const _problemMessage = 'should not has only one child';

  static const _code = const clc.LintCode(
    name: _codeName,
    problemMessage: _problemMessage,
  );

  @override
  Future<void> run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) async {
    context.registry.addInstanceCreationExpression((node) {
      final className = node.staticType?.getDisplayString(
        withNullability: true,
      );

      final type = _WidgetType.fromString(className);

      if (type != null) {
        final children = node.argumentList.arguments
            .where((element) => element.beginToken.lexeme == 'children');
        final childrenNode = children.firstOrNull?.childEntities.lastOrNull;

        if (childrenNode is ListLiteral && childrenNode.elements.length == 1) {
          reporter.reportErrorForNode(
              LintCode(
                name: _codeName,
                problemMessage: '${type.name} $_problemMessage',
                correctionMessage: 'Remove unnecessary ${type.name}',
              ),
              node);
        }
      }
    });
  }
}
