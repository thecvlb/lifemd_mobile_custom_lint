import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

enum _ClassType {
  controller('Controller'),
  service('Service');

  final String name;

  const _ClassType(this.name);
}

class ControllerPublicMemberDocumentation extends DartLintRule {
  ControllerPublicMemberDocumentation() : super(code: _code);

  /// Metadata about the warning that will show-up in the IDE.
  /// This is used for `// ignore: code` and enabling/disabling the lint
  static const _code = const LintCode(
    name: 'controller_public_member_documentation',
    problemMessage: 'Public member should have documentation',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addClassDeclaration((node) {
      final superType = node.declaredElement?.supertype;

      _ClassType? type;
      if (_isControllerOrSubclass(superType)) {
        type = _ClassType.controller;
      } else if (_isServiceOrSubclass(superType) ||
          _isDisposableServiceOrSubclass(superType)) {
        type = _ClassType.service;
      }

      /// Member should be inherited from  GetxController or GetxService or DisposableGetxService
      if (type != null) {
        for (final member in node.members) {
          if (member.documentationComment == null) {
            if (member is MethodDeclaration &&
                member.declaredElement?.isPublic == true &&
                member.declaredElement?.hasOverride != true) {
              /// Highlighting only method name
              reporter.reportErrorForOffset(
                LintCode(
                  name: 'controller_public_member_documentation',
                  problemMessage:
                      "${type.name}'s public member should have documentation",
                ),
                member.name.offset,
                member.declaredElement!.name.length,
              );
            }

            if (member is FieldDeclaration &&
                member.fields.variables.every(
                    (element) => element.declaredElement?.isPublic == true)) {
              reporter.reportErrorForNode(
                LintCode(
                  name: 'controller_public_member_documentation',
                  problemMessage:
                      "${type.name}'s public member should have documentation",
                ),
                member,
              );
            }
          }
        }
      }
    });
  }

  bool _isControllerOrSubclass(DartType? type) =>
      _isController(type) || _isSubclassOfController(type);

  bool _isSubclassOfController(DartType? type) =>
      type is InterfaceType && type.allSupertypes.any(_isController);

  bool _isController(DartType? type) =>
      type?.getDisplayString(withNullability: false) == 'GetxController';

  bool _isServiceOrSubclass(DartType? type) =>
      _isService(type) || _isSubclassOfService(type);

  bool _isSubclassOfService(DartType? type) =>
      type is InterfaceType && type.allSupertypes.any(_isService);

  bool _isService(DartType? type) =>
      type?.getDisplayString(withNullability: false) == 'GetxService';

  bool _isDisposableServiceOrSubclass(DartType? type) =>
      _isDisposableService(type) || _isSubclassOfDisposableService(type);

  bool _isSubclassOfDisposableService(DartType? type) =>
      type is InterfaceType && type.allSupertypes.any(_isDisposableService);

  bool _isDisposableService(DartType? type) =>
      type?.getDisplayString(withNullability: false) == 'DisposableGetxService';
}
