import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:custom_lint_core/custom_lint_core.dart' as clc show LintCode;

class TestDescriptionThenShould extends DartLintRule {
  TestDescriptionThenShould() : super(code: _code);

  static const _codeName = 'test-description-then-should';

  static const _noShouldMessage = 'Then section should have `should` word';

  static const _noSingleShouldMessage =
      'Then section should have single `should` word';

  static const _code = const clc.LintCode(
    name: _codeName,
    problemMessage: _noShouldMessage,
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

        final thenMatch = RegExp(r'(?:#{1,2}\s?)?Then(?:\s(should))?:')
            .firstMatch(description);
        if (thenMatch != null) {
          /// if `## Then should`:
          final isShouldWithNameDefinition = thenMatch.group(1) != null;

          /// offset of ``## Then` in test description
          final thenSectionOffset = thenMatch.start;

          final thenBody = description
              .substring(thenSectionOffset + thenMatch.group(0)!.length);

          /// Amount of `should` in `then` body
          final shouldCount = RegExp(r'\s(should)\s', caseSensitive: false)
              .allMatches(thenBody)
              .length;

          if (isShouldWithNameDefinition) {
            if (shouldCount > 0) {
              _reportErrorForOffset(
                reporter,
                descriptionNode.offset + thenSectionOffset,
                description.length - thenSectionOffset + 1,
                _noSingleShouldMessage,
              );
            }
          } else {
            if (shouldCount == 0) {
              _reportErrorForOffset(
                reporter,
                descriptionNode.offset + thenSectionOffset,
                description.length - thenSectionOffset + 1,
                _noShouldMessage,
              );
            }
          }
        }
      }
    });
  }

  void _reportErrorForOffset(
    ErrorReporter reporter,
    int offset,
    int length,
    String message,
  ) =>
      reporter.atOffset(
        errorCode: clc.LintCode(
          name: _codeName,
          problemMessage: message,
        ),
        offset: offset,
        length: length,
      );
}
