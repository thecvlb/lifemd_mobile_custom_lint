import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class PreferSingleWidgetPerFile extends DartLintRule {
  PreferSingleWidgetPerFile() : super(code: _code);

  static const _code = const LintCode(
    name: 'prefer-single-widget-per-file',
    problemMessage: 'File must contains only one public widget',
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  Future<void> run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) async {
    final unit = await resolver.getResolvedUnitResult();

    final classes =
        unit.libraryElement.topLevelElements.whereType<ClassElement>();

    final widgets =
        classes.where((element) => _isWidgetOrSubclass(element.supertype));

    final publicWidgets =
        widgets.where((element) => element.declaration.isPublic == true);

    if (publicWidgets.length > 1) {
      for (final widget in publicWidgets) {
        reporter.reportErrorForOffset(
          code,
          widget.declaration.nameOffset,
          widget.declaration.nameLength,
        );
      }
    }
  }

  bool _isWidgetOrSubclass(DartType? type) =>
      _isWidget(type) || _isSubclassOfWidget(type);

  bool _isWidget(DartType? type) =>
      type?.getDisplayString(withNullability: false) == 'Widget';

  bool _isSubclassOfWidget(DartType? type) =>
      type is InterfaceType && type.allSupertypes.any(_isWidget);
}
