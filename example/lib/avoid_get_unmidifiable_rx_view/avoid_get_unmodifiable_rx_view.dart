import 'flutter_defines.dart';

class AvoidGetUnmodifiableRxView {
  //expect_lint: avoid-get-unmodifiable-rx-view
  UnmodifiableRxView<bool> get somePublicUnmodifiableRxBoolProperty1 =>
      UnmodifiableRxView<bool>(_property);

  final Rx<bool> _property = Rx(value: true);

  // Some getter
  //expect_lint: avoid-get-unmodifiable-rx-view
  UnmodifiableRxView<bool> get somePublicUnmodifiableRxBoolProperty2 =>
      _property.toUnmodifiableRxView();

  //expect_lint: avoid-get-unmodifiable-rx-view
  /// Some getter
  UnmodifiableRxView<bool> get somePublicUnmodifiableRxBoolProperty3 =>
      _property.toUnmodifiableRxView();

  //expect_lint: avoid-get-unmodifiable-rx-view
  /// Some getter
  UnmodifiableRxView<bool> get somePublicUnmodifiableRxBoolProperty4 =>
      UnmodifiableRxView(_property);
}
