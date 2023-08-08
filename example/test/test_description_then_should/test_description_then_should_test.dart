// ignore_for_file: test-description-single-when-action
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('onInit', () {
    /// Then section should have single `should` word
    test('''.
      ## When:
      - some action called
      // expect_lint: test-description-then-should
      ## Then should: 
      - some method should be called
      ''', () {});

    /// Then section should have `should` word
    test('''.
      ## When:
      - some action called
      // expect_lint: test-description-then-should
      ## Then: 
      - some method be called
      ''', () {});
  });
}
