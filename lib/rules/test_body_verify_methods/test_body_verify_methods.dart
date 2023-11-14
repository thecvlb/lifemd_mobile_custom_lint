import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class TestBodyVerifyMethods extends DartLintRule {
  TestBodyVerifyMethods() : super(code: _code);

  static const _codeName = 'test-body-verify-methods';
  static const _code = const LintCode(
      name: _codeName,
      problemMessage:
          '`Then` section should not contain more than one verify method');

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
        final methodInvocationVisitor = _MethodInvocationVisitor();
        node.visitChildren(methodInvocationVisitor);
        final verifyMethods = methodInvocationVisitor.methods.where(
            (element) => element == 'verify' || element == 'verifyInOrder');

        if (verifyMethods.length > 1) {
          reporter.reportErrorForNode(_code, node);
        }
      }
    });
  }
}

class _MethodInvocationVisitor extends RecursiveAstVisitor<void> {
  final methods = <String>[];

  @override
  void visitFunctionExpressionInvocation(FunctionExpressionInvocation node) {
    super.visitFunctionExpressionInvocation(node);

    methods.add(node.function.toString());
  }
}
