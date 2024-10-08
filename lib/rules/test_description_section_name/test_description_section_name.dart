import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:custom_lint_core/custom_lint_core.dart' as clc show LintCode;

class TestDescriptionSectionName extends DartLintRule {
  TestDescriptionSectionName() : super(code: _code);

  static const _codeName = 'test-description-section-name';

  static const _code = const clc.LintCode(
    name: _codeName,
    problemMessage: 'Test description section name should start with `## `',
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
        final descriptionNode = node.argumentList.arguments.first;
        final description = descriptionNode.toString();

        final matches = RegExp(r'((#{1,2})\s?)?(Given|When|Then(\s(should))?):')
            .allMatches(description);
        for (final section in matches) {
          final prefix = section.group(1);
          if (prefix != '## ') {
            _reportErrorForOffset(
              reporter,
              descriptionNode.offset + section.start,
              section.group(0)!.length,
              '## ${section.group(3)}:',
            );
          }
        }
      }
    });
  }

  @override
  List<Fix> getFixes() => [_PreferCorrectTestDescriptionSectionNameFix()];

  void _reportErrorForOffset(
    ErrorReporter reporter,
    int offset,
    int length,
    String correctionMessage,
  ) =>
      reporter.atOffset(
        errorCode: clc.LintCode(
          name: _codeName,
          problemMessage:
              'Test description section name should start with `## `',
          correctionMessage: correctionMessage,
        ),
        offset: offset,
        length: length,
      );
}

class _PreferCorrectTestDescriptionSectionNameFix extends DartFix {
  _PreferCorrectTestDescriptionSectionNameFix();

  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    context.registry.addMethodInvocation((node) {
      if (!analysisError.sourceRange.intersects(node.sourceRange)) return;

      final correction = analysisError.correctionMessage;

      if (correction != null) {
        final changeBuilder = reporter.createChangeBuilder(
          message: 'Replace by: $correction',
          priority: 0,
        );

        changeBuilder.addDartFileEdit((builder) {
          builder.addSimpleReplacement(
            SourceRange(
              analysisError.sourceRange.offset,
              analysisError.sourceRange.length,
            ),
            correction,
          );
        });
      }
    });
  }
}
