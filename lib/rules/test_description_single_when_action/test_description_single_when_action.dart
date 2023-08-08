import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class TestDescriptionSingleWhenAction extends DartLintRule {
  TestDescriptionSingleWhenAction() : super(code: _code);

  static const _code = const LintCode(
    name: 'test-description-single-when-action',
    problemMessage: '`When` section should have a single action',
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

        final whenMatch = RegExp(
          r'(?:##\s?)?When:(.*)##\s?Then(?:\s(should))?:',
          dotAll: true,
        ).firstMatch(description);

        final whenSection = whenMatch?.group(1);

        if (whenSection != null) {
          final lines = whenSection
              .split('\n')
              .where((element) => element.trim().isNotEmpty);

          if (lines.length > 1) {
            final firstLine = lines.first;
            final offset = firstLine.length - firstLine.trimLeft().length;
            final actions = lines.where((element) =>
                element.length - element.trimLeft().length == offset);

            if (actions.length > 1) {
              reporter.reportErrorForOffset(
                code,
                descriptionNode.offset + description.indexOf(whenSection),
                whenSection.trimRight().length,
              );
            }
          }
        }
      }
    });
  }
}
