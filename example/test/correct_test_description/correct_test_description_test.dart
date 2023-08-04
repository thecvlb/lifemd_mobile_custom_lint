import 'package:flutter_test/flutter_test.dart';

void main() {
  group('onInit', () {
    /// Given must be first
    // expect_lint: correct-test-description
    test('''.
      ## When:
      - some action called
      ## Given:
      - some given condition
      ## Then: 
      - some method should be called
      ''', () {});

    /// Given must be first
    // expect_lint: correct-test-description
    test('''.
      ## Then: 
      - some method should be called
      ## Given:
      - some given condition
      ''', () {});

    /// Should be When or Then section
    // expect_lint: correct-test-description
    test('''.
      ## Given:
      - some given condition
      ''', () {});

    /// When should be second and Then should be third
    // expect_lint: correct-test-description
    test('''.
      ## Given:
      - some given condition
      ## Then: 
      - some method should be called
      ## When:
      - some action called
      ''', () {});

    /// When should be first and Then should be second
    // expect_lint: correct-test-description
    test('''.
      ## Then: 
      - some method should be called
      ## When:
      - some action called
      ''', () {});
  });
}
