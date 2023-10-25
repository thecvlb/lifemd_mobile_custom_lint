import 'flutter_defines.dart';

void main() {
  // expect_lint: avoid-print-and-get-log
  debugPrint('Hello, World!');

  // expect_lint: avoid-print-and-get-log
  Get.log('Hello, World!');
}
