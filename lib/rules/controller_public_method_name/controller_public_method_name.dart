import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:lifemd_mobile_custom_lint/type_utils.dart';

class ControllerPublicMethodName extends DartLintRule {
  ControllerPublicMethodName() : super(code: _code);

  static const PREFIX = 'on';

  static const _code = LintCode(
    name: 'controller_public_method_name',
    problemMessage:
        'Controller public method name should be on<SomethingHappened>',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addClassDeclaration((node) {
      final isController =
          isControllerOrSubclass(node.declaredElement?.supertype);

      if (isController) {
        for (final member in node.members) {
          if (member is MethodDeclaration && !member.isGetter) {
            final element = member.declaredElement;
            if (element?.isPublic == true &&
                !element!.name.startsWith(PREFIX)) {
              /// Highlighting only method name
              reporter.reportErrorForOffset(
                code,
                member.name.offset,
                element.name.length,
              );
            }
          }
        }
      }
    });
  }

  @override
  List<Fix> getFixes() => [_ControllerPublicMethodNameFix()];
}

class _ControllerPublicMethodNameFix extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    context.registry.addMethodDeclaration((node) {
      if (!analysisError.sourceRange.intersects(node.name.sourceRange)) return;

      final currentName = node.name.lexeme;

      final validName =
          '${ControllerPublicMethodName.PREFIX}${currentName[0].toUpperCase()}${currentName.substring(1)}';

      final changeBuilder = reporter.createChangeBuilder(
          message: 'Rename to $validName', priority: 0);

      changeBuilder.addDartFileEdit((builder) {
        builder.addSimpleReplacement(
            SourceRange(node.name.offset, node.name.length), validName);
      });
    });
  }
}
