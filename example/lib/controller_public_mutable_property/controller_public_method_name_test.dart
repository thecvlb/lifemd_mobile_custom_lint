// ignore_for_file: controller_public_member_documentation, unused_field, unused_element
import 'flutter_defines.dart';

class SomeController extends GetxController {
  // expect_lint: controller_public_mutable_property
  Rx<bool> somePublicRxBoolProperty = Rx<bool>();

  Rx<bool> _somePrivateRxBoolProperty = Rx<bool>();

  // expect_lint: controller_public_mutable_property
  RxBool anotherPublicRxBoolProperty = RxBool();

  RxBool _anotherPrivateRxBoolProperty = RxBool();

  // expect_lint: controller_public_mutable_property
  RxList<bool> somePublicRxBoolListProperty = RxList<bool>();

  RxList<bool> _somePrivateRxBoolListProperty = RxList<bool>();

  // expect_lint: controller_public_mutable_property
  List<bool> somePublicBoolListProperty = [];

  List<bool> _somePrivateBoolListProperty = [];

  UnmodifiableRxView<bool> somePublicUnmodifiableRxBoolProperty =
      UnmodifiableRxView<bool>();

  Iterable<bool> somePublicBoolIterableProperty = [];
}

class SomeInheritedController extends SomeController {
  // expect_lint: controller_public_mutable_property
  Rx<bool> somePublicRxBoolProperty1 = Rx<bool>();

  Rx<bool> _somePrivateRxBoolProperty1 = Rx<bool>();

  // expect_lint: controller_public_mutable_property
  RxBool anotherPublicRxBoolProperty1 = RxBool();

  RxBool _anotherPrivateRxBoolProperty1 = RxBool();

  // expect_lint: controller_public_mutable_property
  RxList<bool> somePublicRxBoolListProperty1 = RxList<bool>();

  RxList<bool> _somePrivateRxBoolListProperty1 = RxList<bool>();

  // expect_lint: controller_public_mutable_property
  List<bool> somePublicBoolListProperty1 = [];

  List<bool> _somePrivateBoolListProperty1 = [];

  UnmodifiableRxView<bool> somePublicUnmodifiableRxBoolProperty1 =
      UnmodifiableRxView<bool>();

  Iterable<bool> somePublicBoolIterableProperty1 = [];
}
