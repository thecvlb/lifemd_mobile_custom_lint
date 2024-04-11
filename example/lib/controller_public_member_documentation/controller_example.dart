// ignore_for_file: controller_public_method_name, unused_field, unused_element, class_member_order
import 'flutter_defines.dart';

class SomeController extends GetxController {
  // expect_lint: controller_public_member_documentation
  final bool somePublicField = false;

  final bool _somePrivateField = false;

  // expect_lint: controller_public_member_documentation
  static const bool somePublicConst = false;

  static const bool _somePrivateConst = false;

  // expect_lint: controller_public_member_documentation
  bool get somePublicGetter => true;

  bool get _somePrivateGetter => true;

  // expect_lint: controller_public_member_documentation
  void somePublicMethod() {}

  void _somePrivateMethod() {}
}

class SomeInheritedController extends SomeController {
  // expect_lint: controller_public_member_documentation
  final bool somePublicField1 = false;

  final bool _somePrivateField1 = false;

  // expect_lint: controller_public_member_documentation
  static const bool somePublicConst1 = false;

  static const bool _somePrivateConst1 = false;

  // expect_lint: controller_public_member_documentation
  bool get somePublicGetter1 => true;

  bool get _somePrivateGetter1 => true;

  // expect_lint: controller_public_member_documentation
  void somePublicMethod1() {}

  void _somePrivateMethod1() {}
}
