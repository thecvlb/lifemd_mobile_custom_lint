import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:custom_lint_core/custom_lint_core.dart' as clc show LintCode;
import 'package:lifemd_mobile_custom_lint/type_utils.dart';

enum _ClassType {
  controller('Controller'),
  service('Service');

  final String name;

  const _ClassType(this.name);
}

class ControllerPublicMemberDocumentation extends DartLintRule {
  ControllerPublicMemberDocumentation() : super(code: _code);

  static const _code = const clc.LintCode(
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
      if (isControllerOrSubclass(superType)) {
        type = _ClassType.controller;
      } else if (isServiceOrSubclass(superType) ||
          isDisposableServiceOrSubclass(superType)) {
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
}
