import 'package:flutter_test/flutter_test.dart';

void main() {
  group('onInit', () {
    test('''.
      // expect_lint: prefer-correct-test-description-section-name
      # When:
      - some action called
      // expect_lint: prefer-correct-test-description-section-name
      # Then should: 
      - some method be called
      ''', () {});

    test('''.
      // expect_lint: prefer-correct-test-description-section-name
      # When:
      - some action called
      // expect_lint: prefer-correct-test-description-section-name
      # Then should: 
      - some method be called
      ''', () {});

    test('''.
      // expect_lint: prefer-correct-test-description-section-name
      When:
      - some action called
      // expect_lint: prefer-correct-test-description-section-name
      Then should: 
      - some method be called
      ''', () {});

    test('''.
      // expect_lint: prefer-correct-test-description-section-name
      Given:
      - some action called
      // expect_lint: prefer-correct-test-description-section-name
      Then: 
      - some method should be called
      ''', () {});
  });
}