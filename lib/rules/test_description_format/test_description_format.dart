import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class TestDescriptionFormat extends DartLintRule {
  TestDescriptionFormat() : super(code: _code);

  static const _code = const LintCode(
    name: 'test-description-format',
    problemMessage: 'Test description does not have proper format',
  );

  List<String> get filesToAnalyze => const ['test/**.dart'];

  /// There is no simple way to obtain line offset for method invocation
  /// So check for proper next line offset is skipping
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

        /// `-1` means that description starts in the same line with method invocation
        /// example: `test('''.`
        int startOffset = descriptionNode.offset - node.offset - 6;

        final lines = description.split('\n').where((element) =>
            element.trim().isNotEmpty && !element.trim().startsWith("'''"));

        if (lines.isNotEmpty) {
          if (startOffset < 0) {
            /// Start offset will be obtained from first non empty line
            final firstLine = lines.first;
            startOffset = firstLine.length - firstLine.trimLeft().length;
          }
          int previousOffset = startOffset;

          for (final line in lines) {
            final offset = line.length - line.trimLeft().length;

            /// `offset` should be:
            /// - the same as previous
            /// - or `previous + 2`
            /// - or less than previous but match than start and diff should be even
            if (!(offset == previousOffset ||
                offset == previousOffset + 2 ||
                (offset < previousOffset &&
                    offset >= startOffset &&
                    (offset - startOffset).isEven))) {
              reporter.reportErrorForNode(code, node);

              return;
            }
            if (offset > 0) {
              previousOffset = offset;
            }
          }
        }
      }
    });
  }
}
