import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class TestAvoidFutureDelayed extends DartLintRule {
  TestAvoidFutureDelayed() : super(code: _code);

  static const _codeName = 'test-avoid-future-delayed';
  static const _code = const LintCode(
    name: _codeName,
    problemMessage:
        'Avoid using `Future.delayed` in tests. Use `fakeAsync` and `elapse` instead.',
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
        final functionBodyVisitor = _BlockFunctionBodyVisitor();
        node.visitChildren(functionBodyVisitor);
        final body = functionBodyVisitor.methods.firstOrNull;

        if (body == null) {
          return;
        }

        final parent = body.parent?.parent?.parent;
        if (parent is! MethodInvocation) {
          return;
        }

        if (parent.methodName.name != 'test' &&
            parent.methodName.name != 'fakeAsync') {
          return;
        }

        final functionInvocationVisitor = _ConstructorNameVisitor();
        node.visitChildren(functionInvocationVisitor);

        functionInvocationVisitor.methods.forEach((element) {
          reporter.reportErrorForOffset(
            _code,
            element.offset,
            element.length,
          );
        });
      }
    });
  }
}

class _ConstructorNameVisitor extends RecursiveAstVisitor<void> {
  final methods = <ConstructorName>[];

  @override
  void visitConstructorName(ConstructorName node) {
    super.visitConstructorName(node);

    if (node.type.element?.displayName == 'Future' &&
        node.name?.name == 'delayed') {
      methods.add(node);
    }
  }
}

class _BlockFunctionBodyVisitor extends RecursiveAstVisitor<void> {
  final methods = <BlockFunctionBody>{};

  @override
  void visitBlockFunctionBody(BlockFunctionBody node) {
    super.visitBlockFunctionBody(node);

    methods.add(node);
  }
}
