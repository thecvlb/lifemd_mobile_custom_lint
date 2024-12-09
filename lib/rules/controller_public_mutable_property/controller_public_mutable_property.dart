import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:custom_lint_core/custom_lint_core.dart' as clc show LintCode;
import 'package:lifemd_mobile_custom_lint/type_utils.dart';

class ControllerPublicMutableProperty extends DartLintRule {
  ControllerPublicMutableProperty() : super(code: _code);

  static const _codename = 'controller_public_mutable_property';

  static const _problemMessage =
      'Controller should not expose mutable public property';

  static const _code = const clc.LintCode(
    name: _codename,
    problemMessage: _problemMessage,
  );

  static const _rxChecker = TypeChecker.fromName('Rx');

  static const _rxListChecker = TypeChecker.fromName('RxList');

  static const _listChecker = TypeChecker.fromName('List');

  static const _unmodifiableListChecker =
      TypeChecker.fromName('UnmodifiableListView');

  static const _listCorrectionMessage =
      'UnmodifiableListView or Iterable should be used instead of List';
  static const _rxCorrectionMessage =
      'UnmodifiableRxView should be used instead of Rx or RxList';

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addClassDeclaration((node) {
      final superType = node.declaredElement?.supertype;

      if (isControllerOrSubclass(superType) ||
          isServiceOrSubclass(superType) ||
          isDisposableServiceOrSubclass(superType)) {
        final fields =
            node.members.whereType<FieldDeclaration>().where((element) {
          final name = element.fields.variables.firstOrNull?.name.lexeme;
          return name != null && !Identifier.isPrivateName(name);
        });

        for (final field in fields) {
          final declaredElement =
              field.fields.variables.firstOrNull?.declaredElement;
          if (declaredElement != null) {
            if (_rxChecker.isAssignableFromType(declaredElement.type) ||
                _rxListChecker.isAssignableFromType(declaredElement.type)) {
              reporter.atNode(
                field,
                const clc.LintCode(
                  name: _codename,
                  problemMessage: _problemMessage,
                  correctionMessage: _rxCorrectionMessage,
                ),
              );
            }

            if (_listChecker.isAssignableFromType(declaredElement.type) &&
                !_unmodifiableListChecker.isExactlyType(declaredElement.type)) {
              reporter.atNode(
                field,
                const clc.LintCode(
                  name: _codename,
                  problemMessage: _problemMessage,
                  correctionMessage: _listCorrectionMessage,
                ),
              );
            }
          }
        }
      }
    });
  }
}
