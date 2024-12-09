import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:custom_lint_core/custom_lint_core.dart' as clc show LintCode;

class TestDescriptionThenAvoidSome extends DartLintRule {
  TestDescriptionThenAvoidSome() : super(code: _code);

  static const _codeName = 'test-description-then-avoid-some';

  static const _code = const clc.LintCode(
    name: _codeName,
    problemMessage:
        '`Then` section should not have `some` word. All things in `Then` should be facts and not assumptions.',
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
          /// offset of ``## Then` in test description
          final thenSectionOffset = thenMatch.start;

          final thenBody = description
              .substring(thenSectionOffset + thenMatch.group(0)!.length);

          /// If `some` present in `then` body
          final isSomeExist = RegExp(r'\s(some)\s', caseSensitive: false)
              .allMatches(thenBody)
              .isNotEmpty;

          if (isSomeExist) {
            reporter.atOffset(
              errorCode: _code,
              offset: descriptionNode.offset + thenSectionOffset,
              length: description.length - thenSectionOffset + 1,
            );
          }
        }
      }
    });
  }
}
