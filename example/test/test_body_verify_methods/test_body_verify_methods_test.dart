// ignore_for_file: test-description-single-when-action, test-body-sections
import 'package:flutter_test/flutter_test.dart';

import 'flutter_defines.dart';

void main() {
  group('onInit', () {
    // Several `verify`
    // expect_lint: test-body-verify-methods
    test('''.
      ## Given:
      - some given condition
      ## Then: 
      - some method should be called
      ''', () {
      // Then
      verify(() => {});
      verify(() => {});
      // verifyInOrder([() => {}]);
    });

    // Several `verify`: `verify` and `verifyInOrder`
    // expect_lint: test-body-verify-methods
    test('''.
      ## Given:
      - some given condition
      ## Then: 
      - some method should be called
      ''', () {
      // Then
      verify(() => {});
      verifyInOrder([() => {}]);
    });

    // Several `verifyInOrder`
    // expect_lint: test-body-verify-methods
    test('''.
      ## Given:
      - some given condition
      ## Then: 
      - some method should be called
      ''', () {
      // Then
      verifyInOrder([() => {}]);
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
