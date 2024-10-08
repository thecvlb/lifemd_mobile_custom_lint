import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:custom_lint_core/custom_lint_core.dart' as clc show LintCode;

class TestDescriptionSections extends DartLintRule {
  TestDescriptionSections() : super(code: _code);

  static const _codeName = 'test-description-sections';
  static const _code = const clc.LintCode(
    name: _codeName,
    problemMessage: 'Wrong test description',
  );

  List<String> get filesToAnalyze => const ['test/**.dart'];

  @override
  Future<void> run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) async {
    context.registry.addMethodInvocation((node) {
      final name = node.methodName.name;
      final isTest = name == 'test';
      if (isTest) {
        final description = node.argumentList.arguments.first.toString();

        final givenPosition = description.indexOf("Given:");
        final isGivenExists = givenPosition >= 0;

        final whenPosition = description.indexOf("When:");
        final isWhenExists = whenPosition >= 0;

        final thenPosition = description.indexOf("Then");
        final isThenExists = thenPosition >= 0;

        /// Given (optional, but must be first)
        if (isGivenExists) {
          if ((isWhenExists && givenPosition > whenPosition) ||
              (isThenExists && givenPosition > thenPosition)) {
            _reportErrorForNode(reporter, node, 'Given must be first');
          }
        }

        if (!isWhenExists && !isThenExists) {
          _reportErrorForNode(reporter, node, 'Should be When or Then section');
        }

        if (isWhenExists && isThenExists && whenPosition > thenPosition) {
          if (isGivenExists) {
            _reportErrorForNode(reporter, node,
                'When should be second and Then should be third');
          } else {
            _reportErrorForNode(reporter, node,
                'When should be first and Then should be second');
          }
        }
      }
    });
  }

  void _reportErrorForNode(
    ErrorReporter reporter,
    AstNode node,
    String message,
  ) =>
      reporter.atNode(
        node,
        clc.LintCode(
          name: _codeName,
          problemMessage: 'Wrong test description: $message',
        ),
      );
}
