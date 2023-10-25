// ignore_for_file: test-description-single-when-action, test-body-verify-methods, test-body-sections
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('onInit', () {
    test('''.
      ## When:
      - some action called
      // expect_lint: test-description-then-avoid-some
      ## Then should: 
      - some method called
      ''', () {});

    test('''.
      ## When:
      - some action called
      ## Then: 
      - the same method should be called
      ''', () {});
  });
}
