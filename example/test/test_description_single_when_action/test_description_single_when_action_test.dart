// ignore_for_file: test-description-format, test-body-verify-methods
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('onInit', () {
    test('''.
      // expect_lint: test-description-single-when-action
      ## When:
      - some action called
      - some second action called
      ## Then should: 
      - some method called
      ''', () {});

    test('''.
      ## When:
      - some action called
      ## Then should: 
      - some method be called
      ''', () {});
  });
}
