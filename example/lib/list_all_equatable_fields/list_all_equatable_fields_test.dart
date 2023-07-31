// ignore_for_file: equatable_public_property_documentation
class SomePerson {
  const SomePerson(this.name);

  final String name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SomePerson &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}

class Person extends Equatable {
  const Person(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}

class AnotherPerson extends Equatable {
  const AnotherPerson(this.name, this.age);

  final String name;

  final int age;

  // expect_lint: list-all-equatable-fields
  @override
  List<Object> get props => [name];
}

class AndAnotherPerson extends Equatable {
  static final someProp = 'hello';

  const AndAnotherPerson(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}

class SubPerson extends AndAnotherPerson {
  const SubPerson(this.value, String name) : super(name);

  final int value;

  // expect_lint: list-all-equatable-fields
  @override
  List<Object> get props {
    return super.props..addAll([]);
  }
}

class EquatableDateTimeSubclass extends EquatableDateTime {
  final int century;

  EquatableDateTimeSubclass(
    this.century,
    int year, [
    int month = 1,
    int day = 1,
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
    int microsecond = 0,
  ]) : super(year, month, day, hour, minute, second, millisecond, microsecond);

  // expect_lint: list-all-equatable-fields
  @override
  List<Object> get props => super.props..addAll([]);
}

class EquatableDateTime extends DateTime with EquatableMixin {
  EquatableDateTime(
    int year, [
    int month = 1,
    int day = 1,
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
    int microsecond = 0,
  ]) : super(year, month, day, hour, minute, second, millisecond, microsecond);

  // expect_lint: list-all-equatable-fields
  @override
  List<Object> get props {
    return [
      year,
      month,
      day,
      hour,
      minute,
      second,
      millisecond,
      microsecond,
    ];
  }
}

class Equatable {
  const Equatable();

  List<Object> get props => [];
}

mixin EquatableMixin {
  List<Object?> get props;
}
