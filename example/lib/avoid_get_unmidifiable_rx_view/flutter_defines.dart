class Rx<T> {
  final T value;

  const Rx({required this.value});
}

class UnmodifiableRxView<T> {
  UnmodifiableRxView(Rx<T> value);
}

extension RxExtensions<T> on Rx<T> {
  UnmodifiableRxView<T> toUnmodifiableRxView() => UnmodifiableRxView(this);
}
