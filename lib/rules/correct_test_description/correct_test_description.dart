import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class CorrectTestDescription extends DartLintRule {
  CorrectTestDescription() : super(code: _code);

  static const _code = const LintCode(
    name: 'correct-test-description',
    problemMessage: 'Wrong test description',
    errorSeverity: ErrorSeverity.WARNING,
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
        // final lines = description.split("\n");
        final givenPosition = description.indexOf("## Given:");
        final isGivenExists = givenPosition >= 0;

        final whenPosition = description.indexOf("## When:");
        final isWhenExists = whenPosition >= 0;

        final thenPosition = description.indexOf("## Then");
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

        if (isThenExists && description.indexOf('should', thenPosition) <= 0) {
          _reportErrorForNode(
              reporter, node, 'Then section should have `should` word');
        }

        // final code = LintCode(
        //   name: 'correct-test-description',
        //   problemMessage: 'Wrong test description:${lines.map((e) => '<$e>')}',
        //   errorSeverity: ErrorSeverity.WARNING,
        // );
        // reporter.reportErrorForNode(code, node);
        //
        // // reporter.reportErrorForNode(code, node);
      }
    });
  }

  void _reportErrorForNode(
    ErrorReporter reporter,
    AstNode node,
    String message,
  ) =>
      reporter.reportErrorForNode(
        LintCode(
          name: 'correct-test-description',
          problemMessage: 'Wrong test description: $message',
          errorSeverity: ErrorSeverity.WARNING,
        ),
        node,
      );
}
