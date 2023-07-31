import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:collection/collection.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'flutter_defines.dart';

class PreferCorrectEdgeInsetsConstructor extends DartLintRule {
  PreferCorrectEdgeInsetsConstructor() : super(code: _code);

  static const _className = 'EdgeInsets';
  static const _classNameDirection = 'EdgeInsetsDirectional';

  static const _constructorNameFromLTRB = 'fromLTRB';
  static const _constructorNameFromSTEB = 'fromSTEB';
  static const _constructorNameSymmetric = 'symmetric';
  static const _constructorNameOnly = 'only';

  static const _code = const LintCode(
    name: 'prefer-correct-edge-insets-constructor',
    problemMessage: 'Prefer using correct EdgeInsets constructor.',
    errorSeverity: ErrorSeverity.INFO,
  );

  @override
  Future<void> run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) async {
    context.registry.addInstanceCreationExpression((node) {
      final className = node.staticType?.getDisplayString(
        withNullability: true,
      );

      final constructorName = node.constructorName.name?.name;

      if (className == _className || className == _classNameDirection) {
        EdgeInsetsData? data;
        switch (constructorName) {
          case _constructorNameOnly:
          case _constructorNameSymmetric:
            data = _parseNamedParams(node, constructorName, className);
            break;
          case _constructorNameFromLTRB:
          case _constructorNameFromSTEB:
            data = _parsePositionParams(node, constructorName, className);
            break;
        }

        if (data != null) {
          final correctionMessage = _validate(data);
          if (correctionMessage != null) {
            final code = LintCode(
              name: 'prefer-correct-edge-insets-constructor',
              problemMessage: 'Prefer using correct EdgeInsets constructor.',
              correctionMessage: correctionMessage,
              errorSeverity: ErrorSeverity.INFO,
            );

            reporter.reportErrorForNode(code, node);
          }
        }
      }
    });
  }

  @override
  List<Fix> getFixes() => [_PreferCorrectEdgeInsetsConstructorFix()];

  EdgeInsetsData? _parseNamedParams(
    InstanceCreationExpression expression,
    String? constructorName,
    String? className,
  ) {
    final argumentsList = <EdgeInsetsParam?>[];
    for (final expression in expression.argumentList.arguments) {
      final variable = expression.childEntities.last;
      if (variable is IntegerLiteral || variable is DoubleLiteral) {
        final name = expression.beginToken.toString();
        final value = expression.endToken.toString();

        argumentsList.add(EdgeInsetsParam(
          name: name,
          value: num.tryParse(value),
        ));
      } else {
        argumentsList.add(null);
      }
    }

    if (!argumentsList.contains(null)) {
      final param = argumentsList.whereType<EdgeInsetsParam>().toList();
      return EdgeInsetsData(
        className ?? '',
        constructorName ?? '',
        param,
      );
    }

    return null;
  }

  EdgeInsetsData? _parsePositionParams(
    InstanceCreationExpression expression,
    String? constructorName,
    String? className,
  ) {
    final arguments = expression.argumentList.arguments;
    if (arguments.length == 4 &&
        arguments.every(
          (element) => element is IntegerLiteral || element is DoubleLiteral,
        )) {
      final argumentsList = arguments
          .map((e) => EdgeInsetsParam(value: num.tryParse(e.toString())))
          .toList();

      return EdgeInsetsData(
        className ?? '',
        constructorName ?? '',
        argumentsList,
      );
    }

    return null;
  }

  String? _validate(EdgeInsetsData data) {
    switch (data.constructorName) {
      case _constructorNameFromSTEB:
      case _constructorNameFromLTRB:
        return _validateFromSTEB(data);
      case _constructorNameSymmetric:
        return _validateSymmetric(data);
      case _constructorNameOnly:
        return _validateFromOnly(data);
      default:
        return null;
    }
  }

  String? _validateSymmetric(EdgeInsetsData data) {
    final param = data.params;
    final vertical = param.firstWhereOrNull((e) => e.name == 'vertical')?.value;
    final horizontal =
        param.firstWhereOrNull((e) => e.name == 'horizontal')?.value;

    final isParamsSame = vertical == horizontal && horizontal != null;
    final isAllParamsZero = isParamsSame && horizontal == 0;

    if (isAllParamsZero) {
      return _replaceWithZero();
    }

    if (isParamsSame) {
      return 'const ${data.className}.all($horizontal)';
    }

    if (horizontal == 0 && vertical != null) {
      return _replaceWithSymmetric('vertical: $vertical');
    }
    if (vertical == 0 && horizontal != null) {
      return _replaceWithSymmetric('horizontal: $horizontal');
    }

    return null;
  }

  String? _validateFromOnly(EdgeInsetsData data) {
    {
      final param = data.params;
      final top = param.firstWhereOrNull((e) => e.name == 'top')?.value;
      final bottom = param.firstWhereOrNull((e) => e.name == 'bottom')?.value;
      final left = param
          .firstWhereOrNull((e) => e.name == 'left' || e.name == 'start')
          ?.value;
      final right = param
          .firstWhereOrNull((e) => e.name == 'right' || e.name == 'end')
          ?.value;

      final paramsList = [top, bottom, left, right];
      final hasLeftParam = left != 0 && left != null;
      final hasTopParam = top != 0 && top != null;
      final hasBottomParam = bottom != 0 && bottom != null;
      final hasRightParam = right != 0 && right != null;
      if (paramsList.every((element) => element == 0)) {
        return _replaceWithZero();
      }

      if (paramsList.every((element) => element == top && top != null)) {
        return 'const ${data.className}.all(${data.params.first.value})';
      }

      if (left == right && hasLeftParam && top == bottom && hasTopParam) {
        final params = 'horizontal: $right, vertical: $top';

        return _replaceWithSymmetric(params);
      }

      if (top == bottom && top != 0 && !hasLeftParam && !hasRightParam) {
        return _replaceWithSymmetric('vertical: $top');
      }

      if (left == right && right != 0 && !hasTopParam && !hasBottomParam) {
        return _replaceWithSymmetric('horizontal: $right');
      }

      if (paramsList.contains(0)) {
        return 'const ${data.className}.only(${[
          if (hasTopParam) 'top: $top',
          if (hasBottomParam) 'bottom: $bottom',
          if (hasLeftParam && data.className == 'EdgeInsetsDirectional')
            'start: $left',
          if (hasLeftParam && data.className == 'EdgeInsets') 'left: $left',
          if (hasRightParam && data.className == 'EdgeInsetsDirectional')
            'end: $right',
          if (hasRightParam && data.className == 'EdgeInsets') 'right: $right',
        ].join(', ')})';
      }
    }

    return null;
  }

  String? _validateFromSTEB(
    EdgeInsetsData data,
  ) {
    if (data.params.every((element) => element.value == 0)) {
      return _replaceWithZero();
    }

    if (data.params
        .every((element) => element.value == data.params.first.value)) {
      return 'const ${data.className}.all(${data.params.first.value})';
    }

    final left = data.params.first.value;
    final top = data.params.elementAt(1).value;
    final right = data.params.elementAt(2).value;
    final bottom = data.params.elementAt(3).value;

    if (left == right && top == bottom) {
      final params = <String>[];
      if (left != 0) {
        params.add('horizontal: $left');
      }
      if (top != 0) {
        params.add('vertical: $top');
      }

      return _replaceWithSymmetric(params.join(', '));
    }

    if (data.params.any((element) => element.value == 0)) {
      final params = <String>[];

      if (left != 0) {
        if (data.constructorName == _constructorNameFromLTRB) {
          params.add('left: $left');
        } else {
          params.add('start: $left');
        }
      }
      if (top != 0) {
        params.add('top: $top');
      }

      if (right != 0) {
        if (data.constructorName == _constructorNameFromLTRB) {
          params.add('right: $right');
        } else {
          params.add('end: $right');
        }
      }

      if (bottom != 0) {
        params.add('bottom: $bottom');
      }

      return 'const ${data.className}.only(${params.join(', ')})';
    }

    return null;
  }

  String _replaceWithZero() => 'EdgeInsets.zero';

  String _replaceWithSymmetric(String? param) =>
      'const EdgeInsets.symmetric($param)';
}

class _PreferCorrectEdgeInsetsConstructorFix extends DartFix {
  _PreferCorrectEdgeInsetsConstructorFix();

  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      if (analysisError.sourceRange != node.sourceRange) return;

      final correction = analysisError.correctionMessage;

      if (correction != null) {
        final changeBuilder = reporter.createChangeBuilder(
            message: 'Replace by: $correction', priority: 0);

        changeBuilder.addDartFileEdit((builder) {
          builder.addSimpleReplacement(
            SourceRange(node.offset, node.length),
            correction,
          );
        });
      }
    });
  }
}
