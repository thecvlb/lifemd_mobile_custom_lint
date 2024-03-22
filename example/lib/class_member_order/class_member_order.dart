// ignore_for_file: unused_field, unused_element

class SomeClass {
  final int _someIntField;

  final String? _someStringField;

  final List<int> _someListField;

  SomeClass(
      {required int someIntField,
      String? someStringField,
      List<int> someListField = const []})
      : _someListField = someListField,
        _someStringField = someStringField,
        _someIntField = someIntField;

  SomeClass.named({
    required int someIntField,
    String? someStringField,
    List<int> someListField = const [],
  })  : _someListField = someListField,
        _someStringField = someStringField,
        _someIntField = someIntField;

  factory SomeClass._fromJson(Map<String, dynamic> json) {
    return SomeClass(
      someIntField: json['someIntField'] as int,
      someStringField: json['someStringField'] as String?,
    );
  }

  factory SomeClass.fromJson(Map<String, dynamic> json) {
    return SomeClass(
      someIntField: json['someIntField'] as int,
      someStringField: json['someStringField'] as String?,
    );
  }

  final int _someIntField2 = 0;

  int get someIntField => _someIntField;

  String someMethod() => '$someIntField->someMethod';
}
