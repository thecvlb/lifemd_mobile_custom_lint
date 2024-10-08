import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:custom_lint_core/custom_lint_core.dart' as clc show LintCode;

class AvoidGetUnmodifiableRxView extends DartLintRule {
  AvoidGetUnmodifiableRxView() : super(code: _code);

  static const _codeName = 'avoid-get-unmodifiable-rx-view';
  static const _description =
      'If getter returns UnmodifiableRxView, it should be converted to final property';

  static const _code =
      const clc.LintCode(name: _codeName, problemMessage: _description);

  static const _checker = TypeChecker.fromName('UnmodifiableRxView');

  @override
  Future<void> run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) async {
    context.registry.addMethodDeclaration((node) {
      if (node.isGetter &&
          node.returnType?.type != null &&
          _checker.isAssignableFromType(node.returnType!.type!)) {
        reporter.atNode(node, _code);
      }
    });
  }

  @override
  List<Fix> getFixes() => [_AvoidGetUnmodifiableRxViewFix()];
}

class _AvoidGetUnmodifiableRxViewFix extends DartFix {
  final _getterBodyRegExp =
      RegExp(r'\s*=>\s+(_(\w+))\.toUnmodifiableRxView\(\);');

  final _getterBodyRegExp2 = RegExp(r'\s*=>\s+UnmodifiableRxView\((_(\w+))\);');

  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    context.registry.addMethodDeclaration((node) {
      if (!analysisError.sourceRange.intersects(node.sourceRange)) return;

      final body = node.body.toString();

      final res = _getterBodyRegExp.firstMatch(body);
      if (res != null && res.groupCount > 1) {
        final fix =
            'late final ${node.returnType} ${node.name} = UnmodifiableRxView(${res.group(1)});';

        build(reporter, node, fix);

        return;
      }

      final res2 = _getterBodyRegExp2.firstMatch(body);
      if (res2 != null && res2.groupCount > 1) {
        final fix =
            'late final ${node.returnType} ${node.name} = UnmodifiableRxView(${res2.group(1)});';

        build(reporter, node, fix);

        return;
      }
    });
  }

  void build(ChangeReporter reporter, MethodDeclaration node, String fix) {
    final changeBuilder =
        reporter.createChangeBuilder(message: fix, priority: 0);

    final docLength =
        node.firstTokenAfterCommentAndMetadata.offset - node.offset;

    changeBuilder.addDartFileEdit((builder) {
      builder.addSimpleReplacement(
        SourceRange(
          node.firstTokenAfterCommentAndMetadata.offset,
          node.length - docLength,
        ),
        fix,
      );
    });
  }
}
