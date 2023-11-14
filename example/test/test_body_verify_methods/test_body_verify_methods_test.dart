// ignore_for_file: test-description-single-when-action, test-body-sections, test-description-then-avoid-some
import 'package:flutter_test/flutter_test.dart';

import 'flutter_defines.dart';

void main() {
  group('onInit', () {
    // Several `verify`
    test('''.
      ## Given:
      - some given condition
      ## Then: 
      - some method should be called
      ''', () {
      // Then
      // expect_lint: test-body-verify-methods
      verify(() => {});
      // expect_lint: test-body-verify-methods
      verify(() => {});
    });

    // Several `verify`: `verify` and `verifyInOrder`
    test('''.
      ## Given:
      - some given condition
      ## Then: 
      - some method should be called
      ''', () {
      // Then
      // expect_lint: test-body-verify-methods
      verify(() => {});
      // expect_lint: test-body-verify-methods
      verifyInOrder([() => {}]);
    });

    // Several `verifyInOrder`
    test('''.
      ## Given:
      - some given condition
      ## Then: 
      - some method should be called
      ''', () {
      // Then
      // expect_lint: test-body-verify-methods
      verifyInOrder([() => {}]);
      // expect_lint: test-body-verify-methods
      verifyInOrder([() => {}]);
    });

    // Correct body: single `verify`
    test('''.
      ## Given:
      - some given condition
      ## Then: 
      - some method should be called
      ''', () {
      // Then
      verify(() => {});
    });

    // Correct body: single `verifyInOrder`
    test('''.
      ## Given:
      - some given condition
      ## Then: 
      - some method should be called
      ''', () {
      // Then
      verifyInOrder([() => {}]);
    });
  });
}
