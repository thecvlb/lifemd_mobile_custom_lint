// ignore_for_file: list-all-equatable-fields
class Person extends Equatable {
  const Person(this.name);

  // expect_lint: equatable_public_property_documentation
  final String name;

  @override
  List<Object> get props => [name];
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

class EquatableDateTimeSubclass extends EquatableDateTime {
  // expect_lint: equatable_public_property_documentation
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

  @override
  List<Object> get props => super.props..addAll([]);
}

class Equatable {
  const Equatable();

  List<Object> get props => [];
}

mixin EquatableMixin {
  List<Object?> get props;
}
