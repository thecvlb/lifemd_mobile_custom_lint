import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../../type_utils.dart';

enum _OrderedType {
  constructorField(
      priority: 0, name: 'properties initialized by the constructor'),
  unnamedConstructor(priority: 1, name: 'unnamed constructor'),
  privateNamedConstructor(priority: 2, name: 'private named constructor'),
  publicNamedConstructor(priority: 3, name: 'public named constructor'),
  privateFactory(priority: 4, name: 'private factory'),
  publicFactory(priority: 5, name: 'public factory'),
  getter(priority: 6, name: 'getter'),
  field(priority: 6, name: 'property'),
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

  static const _code = const LintCode(
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

      final members = <_ClassMember>[];

      // find all the members of the class
      node.members.forEach((member) {
        final isFieldDeclaration = member is FieldDeclaration;
        final isConstructorDeclaration = member is ConstructorDeclaration;
        final isMethodDeclaration = member is MethodDeclaration;

        if (isFieldDeclaration) {
          members.add(_ClassMember(
            member: member,
            type: _OrderedType.field,
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

      // determine the final properties initialized by the constructor
      final initializers = <String>[];
      members.forEach((member) {
        if (member.member is ConstructorDeclaration) {
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
        }
      });

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
      for (int i = 0; i < members.length - 1; i++) {
        final current = members[i];
        final next = members[i + 1];

        if (current.type.priority > next.type.priority) {
          reporter.reportErrorForNode(
            LintCode(
              name: 'class_member_order',
              problemMessage:
                  'Wrong class member order: `${current.type.name}` should be after `${next.type.name}`',
            ),
            current.member,
          );
        }
      }

      // members.forEach((member) {
      //   reporter.reportErrorForNode(
      //     LintCode(
      //       name: 'class_member_order',
      //       // problemMessage:
      //       //     'Mem:${member.declaredElement?.kind}->${member.declaredElement?.name},${member.declaredElement?.kind},$isFieldDeclaration',
      //       problemMessage:
      //           'Mem:${member.type}->${member.name}=>${member.member}->${members.length},',
      //     ),
      //     member.member,
      //   );
      // });
    });
  }

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

  _OrderedType _getMethodType(MethodDeclaration member) {
    if (member.isGetter) {
      return _OrderedType.getter;
    }

    return _OrderedType.methods;
  }
}
