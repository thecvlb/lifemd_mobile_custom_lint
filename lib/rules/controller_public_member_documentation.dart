import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

enum _ClassType {
  controller,
  service;
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
      final superTypes =
          node.declaredElement?.allSupertypes.map((e) => e.element.name);

      _ClassType? type;
      if (superTypes?.contains('GetxController') == true) {
        type = _ClassType.controller;
      } else if (superTypes?.contains('GetxService') == true ||
          superTypes?.contains('DisposableGetxService') == true) {
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
                code,
                member.name.offset,
                member.declaredElement!.name.length,
              );
            }

            if (member is FieldDeclaration &&
                member.fields.variables.every(
                    (element) => element.declaredElement?.isPublic == true)) {
              reporter.reportErrorForNode(code, member);
            }
          }
        }
      }
    });
  }
}
