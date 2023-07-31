// ignore_for_file: prefer-correct-test-file-name, unused_field, unused_element

// expect_lint: avoid-top-level-members-in-tests
final public = 1;
final _private = 2;

void main() {
  void function1() {}
}

// expect_lint: avoid-top-level-members-in-tests
void function() {}

void _function() {}

// expect_lint: avoid-top-level-members-in-tests
class Class {}

class _Class {}

// expect_lint: avoid-top-level-members-in-tests
mixin Mixin {}

mixin _Mixin {}

// expect_lint: avoid-top-level-members-in-tests
extension Extension on String {}

extension _Extension on String {}

// expect_lint: avoid-top-level-members-in-tests
enum Enum { first, second }

enum _Enum { first, second }

// expect_lint: avoid-top-level-members-in-tests
typedef Public = String;

typedef _Private = String;
