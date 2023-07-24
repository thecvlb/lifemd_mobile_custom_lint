import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class EquatablePublicPropertyDocumentation extends DartLintRule {
  EquatablePublicPropertyDocumentation() : super(code: _code);

  /// Metadata about the warning that will show-up in the IDE.
  /// This is used for `// ignore: code` and enabling/disabling the lint
  static const _code = const LintCode(
    name: 'equatable_public_property_documentation',
    problemMessage: 'Equatable public property should have documentation',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addClassDeclaration((node) {
      final classType = node.extendsClause?.superclass.type;

      final isEquatable = _isEquatableOrSubclass(classType);

      final isMixin = node.withClause?.mixinTypes
              .any((mixinType) => _isEquatableMixin(mixinType.type)) ??
          false;
      final isSubclassOfMixin = _isSubclassOfEquatableMixin(classType);

      if (!isEquatable && !isMixin && !isSubclassOfMixin) {
        return;
      }

      for (final member in node.members) {
        if (member.documentationComment == null &&
            member is FieldDeclaration &&
            member.fields.variables.every(
                (element) => element.declaredElement?.isPublic == true)) {
          reporter.reportErrorForNode(code, member);
        }
      }
    });
  }

  bool _isEquatableOrSubclass(DartType? type) =>
      _isEquatable(type) || _isSubclassOfEquatable(type);

  bool _isSubclassOfEquatable(DartType? type) =>
      type is InterfaceType && type.allSupertypes.any(_isEquatable);

  bool _isEquatable(DartType? type) =>
      type?.getDisplayString(withNullability: false) == 'Equatable';

  bool _isEquatableMixin(DartType? type) =>
      // ignore: deprecated_member_use
      type?.element2 is MixinElement &&
      type?.getDisplayString(withNullability: false) == 'EquatableMixin';

  bool _isSubclassOfEquatableMixin(DartType? type) {
    // ignore: deprecated_member_use
    final element = type?.element2;

    return element is ClassElement && element.mixins.any(_isEquatableMixin);
  }
}
