import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:collection/collection.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:lifemd_mobile_custom_lint/type_utils.dart';

class ListAllEquatableFields extends DartLintRule {
  ListAllEquatableFields() : super(code: _code);

  static const _code = const LintCode(
    name: 'list-all-equatable-fields',
    problemMessage: 'All equatable fields must be added to props',
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

      final fieldNames = node.members
          .whereType<FieldDeclaration>()
          .whereNot((field) => field.isStatic)
          .map((declaration) =>
              declaration.fields.variables.firstOrNull?.name.lexeme)
          .whereNotNull()
          .toSet();

      if (isMixin) {
        fieldNames.addAll(_getParentFields(classType));
      }

      final props = node.members.firstWhereOrNull((declaration) =>
          declaration is MethodDeclaration &&
          declaration.isGetter &&
          declaration.name.lexeme == 'props') as MethodDeclaration?;

      if (props == null) {
        return;
      }

      final literalVisitor = _ListLiteralVisitor();
      props.body.visitChildren(literalVisitor);

      final expression = literalVisitor.literals.firstOrNull;
      if (expression != null) {
        final usedFields = expression.elements
            .whereType<SimpleIdentifier>()
            .map((identifier) => identifier.name)
            .toSet();

        if (!usedFields.containsAll(fieldNames)) {
          final missingFields = fieldNames.difference(usedFields).join(', ');
          final newCode = LintCode(
            name: 'list-all-equatable-fields',
            problemMessage: 'Missing declared class fields: $missingFields',
            correctionMessage: 'Add to declaration: $missingFields ',
            errorSeverity: ErrorSeverity.WARNING,
          );
          reporter.reportErrorForNode(newCode, props);
        }
      }
    });
  }

  Set<String> _getParentFields(DartType? classType) {
    // ignore: deprecated_member_use
    final element = classType?.element2;
    if (element is! ClassElement) {
      return {};
    }

    return element.fields
        .where(
          (field) =>
              !field.isStatic &&
              !field.isConst &&
              !field.isPrivate &&
              field.name != 'hashCode',
        )
        .map((field) => field.name)
        .toSet();
  }
}

class _ListLiteralVisitor extends RecursiveAstVisitor<void> {
  final literals = <ListLiteral>{};

  @override
  void visitListLiteral(ListLiteral node) {
    super.visitListLiteral(node);

    literals.add(node);
  }
}
