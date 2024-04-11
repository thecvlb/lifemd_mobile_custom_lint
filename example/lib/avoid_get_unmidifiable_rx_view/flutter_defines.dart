class Rx<T> {}

class UnmodifiableRxView<T> {}

extension RxExtensions<T> on Rx<T> {
  UnmodifiableRxView<T> toUnmodifiableRxView() => UnmodifiableRxView();
}
