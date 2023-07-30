// ignore_for_file: controller_public_member_documentation, unused_element

import 'flutter_defines.dart';

class SomeController extends GetxController {
  // expect_lint: controller_public_method_name
  void somePublicMethodWithWrongName() {}

  void _somePrivateMethod() {}

  void onSomethingHappened() {}

  void _onSomethingHappened() {}
}

class SomeInheritedController extends SomeController {
  // expect_lint: controller_public_method_name
  void somePublicMethodWithWrongName1() {}

  void _somePrivateMethod1() {}

  void onSomethingHappened1() {}

  void _onSomethingHappened1() {}
}
