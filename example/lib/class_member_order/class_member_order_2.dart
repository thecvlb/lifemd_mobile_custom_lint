// ignore_for_file: unused_field, unused_element

class SomeClass {
  final int someIntField;

  final String? someStringField;

  SomeClass({this.someIntField = 0, this.someStringField});

  final _privateProperty1 = 0;

  final _privateProperty2 = 0;

  //expect_lint: class_member_order
  int get privateProperty1 => _privateProperty1;

  final _privateProperty3 = 0;

  //expect_lint: class_member_order
  int get privateProperty2 => _privateProperty2;
}
