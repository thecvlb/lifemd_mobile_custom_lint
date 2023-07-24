import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:lifemd_mobile_custom_lint/type_utils.dart';

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

      final isEquatable = isEquatableOrSubclass(classType);

      final isMixin = node.withClause?.mixinTypes
              .any((mixinType) => isEquatableMixin(mixinType.type)) ??
          false;
      final isSubclassOfMixin = isSubclassOfEquatableMixin(classType);

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
}
