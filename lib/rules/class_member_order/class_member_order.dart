import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/listener.dart';
import 'package:collection/collection.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:custom_lint_core/custom_lint_core.dart' as clc show LintCode;

import '../../type_utils.dart';

enum _OrderedType {
  staticMember(priority: 0, name: 'static member'),
  constructorField(
      priority: 1, name: 'properties initialized by the constructor'),
  unnamedConstructor(priority: 2, name: 'unnamed constructor'),
  privateNamedConstructor(priority: 3, name: 'private named constructor'),
  publicNamedConstructor(priority: 4, name: 'public named constructor'),
  privateFactory(priority: 5, name: 'private factory'),
  publicFactory(priority: 6, name: 'public factory'),
  getter(priority: 7, name: 'getter'),
  field(priority: 7, name: 'property'),
  methods(priority: 7, name: 'method');

  final int priority;
  final String name;

  const _OrderedType({required this.priority, required this.name});
}

class _ClassMember {
  final _OrderedType type;
  final String name;

  final ClassMember member;

  _ClassMember({
    required this.member,
    required this.type,
    required this.name,
  });

  _ClassMember copyWith({required _OrderedType type}) => _ClassMember(
        member: this.member,
        name: this.name,
        type: type,
      );
}

class ClassMemberOrder extends DartLintRule {
  ClassMemberOrder() : super(code: _code);

  static const _code = const clc.LintCode(
    name: 'class_member_order',
    problemMessage: 'Wrong order of class members',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addClassDeclaration((node) {
      final superType = node.declaredElement?.supertype;
      if (isWidgetOrSubclass(superType)) {
        return;
      }

      final members = _getClassMembers(node);

      // determine the final properties initialized by the constructor
      final initializers = _getConstructorInitializers(
          members.where((element) => element.member is ConstructorDeclaration));

      // change the type of the field to constructorField if it is initialized in the constructor
      for (int i = 0; i < members.length; i++) {
        final member = members[i];
        if (member.type == _OrderedType.field) {
          if (initializers.contains(member.name)) {
            members[i] = member.copyWith(type: _OrderedType.constructorField);
          }
        }
      }

      // find the not correct order of the members
      _findIncorrectOrder(members, reporter);
      _findIncorrectOrderOfGetters(
          members
              .where((element) =>
                  element.type == _OrderedType.field ||
                  element.type == _OrderedType.getter)
              .toList(),
          reporter);
    });
  }

  /// Get all the members of the class
  List<_ClassMember> _getClassMembers(ClassDeclaration node) {
    final members = <_ClassMember>[];

    // find all the members of the class
    node.members.forEach((member) {
      final isFieldDeclaration = member is FieldDeclaration;
      final isConstructorDeclaration = member is ConstructorDeclaration;
      final isMethodDeclaration = member is MethodDeclaration;

      if (isFieldDeclaration) {
        members.add(_ClassMember(
          member: member,
          type:
              member.isStatic ? _OrderedType.staticMember : _OrderedType.field,
          name: member.fields.variables.first.name.lexeme,
        ));
      }

      if (isConstructorDeclaration) {
        members.add(_ClassMember(
          member: member,
          type: _getConstructorType(member),
          name: member.name?.lexeme ?? '',
        ));
      }

      if (isMethodDeclaration) {
        members.add(_ClassMember(
          member: member,
          type: _getMethodType(member),
          name: member.name.lexeme,
        ));
      }
    });

    return members;
  }

  /// Get the type of the constructor
  _OrderedType _getConstructorType(ConstructorDeclaration member) {
    if (member.name == null) {
      return _OrderedType.unnamedConstructor;
    }

    if (member.declaredElement?.isFactory == true) {
      if (member.declaredElement?.isPrivate == true) {
        return _OrderedType.privateFactory;
      }

      return _OrderedType.publicFactory;
    }

    if (member.declaredElement?.isPrivate == true) {
      return _OrderedType.privateNamedConstructor;
    }

    return _OrderedType.publicNamedConstructor;
  }

  /// Get the type of the method
  _OrderedType _getMethodType(MethodDeclaration member) {
    if (member.isGetter) {
      return _OrderedType.getter;
    }

    return _OrderedType.methods;
  }

  /// Get the properties initialized by the constructor
  List<String> _getConstructorInitializers(
      Iterable<_ClassMember> constructors) {
    final initializers = <String>[];
    constructors.forEach((member) {
      final constructor = member.member as ConstructorDeclaration;
      constructor.initializers.forEach((initializer) {
        if (initializer is ConstructorFieldInitializer) {
          initializers.add(initializer.fieldName.name);
        }
      });

      constructor.parameters.parameters.forEach((parameter) {
        final name = parameter.name?.lexeme;
        if (name != null) {
          initializers.add(name);
        }
      });
    });
    return initializers;
  }

  /// Find the incorrect order of the members
  /// depend on the priority of the type
  void _findIncorrectOrder(List<_ClassMember> members, ErrorReporter reporter) {
    for (int i = 0; i < members.length - 1; i++) {
      final current = members[i];
      final next = members[i + 1];

      if (current.type.priority > next.type.priority) {
        reporter.atNode(
          current.member,
          clc.LintCode(
            name: 'class_member_order',
            problemMessage:
                'Wrong class member order: `${current.type.name}` should be after `${next.type.name}`',
          ),
        );
      }
    }
  }

  /// It's good practice to place a getter for private property right below it
  void _findIncorrectOrderOfGetters(
      List<_ClassMember> members, ErrorReporter reporter) {
    members.forEachIndexed(
      (index, element) {
        final current = element;

        // find public getter
        if (current.type == _OrderedType.getter &&
            !Identifier.isPrivateName(current.name)) {
          // find the private field with the same name
          final fieldIndex = members.indexWhere((member) =>
              member.name == '_${current.name}' &&
              member.type == _OrderedType.field);

          if (fieldIndex >= 0 && fieldIndex != index - 1) {
            final field = members[fieldIndex];

            reporter.atNode(
              current.member,
              clc.LintCode(
                name: 'class_member_order',
                problemMessage:
                    'Wrong class member order: `${current.name}` should be placed below `${field.name}`',
              ),
            );
          }
        }
      },
    );
  }
}
