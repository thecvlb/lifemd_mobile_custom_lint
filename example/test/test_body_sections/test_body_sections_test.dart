// ignore_for_file: test-description-single-when-action, test-description-then-avoid-some
import 'package:flutter_test/flutter_test.dart';

import 'flutter_defines.dart';

void main() {
  group('Body should contain only one instance of the same section ', () {
    test('''.
      ## Given: 
      - some method should be called
      ## Then: 
      - some method should be called
      ''', ()
        // Test body should have only one `Given` section
        // expect_lint: test-body-sections
        {
      // Given
      foo();

      // Given
      foo();

      // Then
      foo();
    });

    test('''.
      ## When: 
      - some method should be called
      ''', ()
        // Test body should have only one `When` section
        // expect_lint: test-body-sections
        {
      // When
      foo();

      // When
      foo();
    });

    test('''.
      ## Then: 
      - some method should be called
      ''', ()
        // Test body should have only one `Then` section
        // expect_lint: test-body-sections
        {
      // Then
      foo();

      // Then
      foo();
    });
  });

  group('Body should contain all sections from description ', () {
    test('''.
      ## When: 
      - some method should be called
      ''', ()
        // Correct: both description and body contain `When` section
        {
      // When
      foo();
    });

    test('''.
      ## When: 
      - some method should be called
      ''', ()
        // Test description contains `When` section but body does not
        // expect_lint: test-body-sections
        {
      foo();
    });

    test('''.
      ## Then: 
      - some method should be called
      ''', ()
        // Correct: both description and body contain `Then` section
        {
      // Then
      foo();
    });

    test('''.
      ## Then: 
      - some method should be called
      ''', ()
        // Test description contains `Then` section but body does not
        // expect_lint: test-body-sections
        {
      foo();
    });

    test('''.
      ## Given:
      - some given condition
      ## When: 
      - some method should be called
      ''', ()
        // Test description contains `Given` section but body does not
        // expect_lint: test-body-sections
        {
      // When
      foo();
    });

    test('''.
      ## Given:
      - some given condition
      ## When: 
      - some method should be called
      ''', ()
        // Correct: both description and body contain `Given` and `When` sections
        {
      // Given
      foo();

      // When
      foo();
    });

    test('''.
      ## Given:
      - some given condition
      ## Then: 
      - some method should be called
      ''', ()
        // Test description contains `Given` section but body does not
        // expect_lint: test-body-sections
        {
      // Then
      foo();
    });

    test('''.
      ## Given:
      - some given condition
      ## Then: 
      - some method should be called
      ''', ()
        // Correct: both description and body contain `Given` and `Then` sections
        {
      // Given
      foo();

      // Then
      foo();
    });

    test('''.
      ## Given:
      - some given condition
      ## When: 
      - some method should be called
      ## Then: 
      - some method should be called
      ''', ()
        // Test description contains `Given` section but body does not
        // expect_lint: test-body-sections
        {
      // When
      foo();

      // Then
      foo();
    });

    test('''.
      ## Given:
      - some given condition
      ## When: 
      - some method should be called
      ## Then: 
      - some method should be called
      ''', ()
        // Correct: both description and body contain `Given`, `When` and `Then` sections
        {
      // Given
      foo();

      // When
      foo();

      // Then
      foo();
    });
  });

  group('Test description and body should have the same sections order', () {
    test('''.
      ## Given:
      - some given condition
      ## When: 
      - some method should be called
      ## Then: 
      - some method should be called
      ''', ()
        // Test description and body should have the same sections order
        // expect_lint: test-body-sections
        {
      // Given
      foo();

      // Then
      foo();

      // When
      foo();
    });

    test('''.
      ## Given:
      - some given condition
      ## When: 
      - some method should be called
      ## Then: 
      - some method should be called
      ''', ()
        // Test description and body should have the same sections order
        // expect_lint: test-body-sections
        {
      // Then
      foo();

      // Given
      foo();

      // When
      foo();
    });
  });
}
