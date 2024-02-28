// ignore_for_file: test-description-single-when-action, test-body-sections, test-description-then-avoid-some
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('onInit', () {
    test('''.
      ## When: 
      - some method should be called
      ''', () {
      // When
      // expect_lint: test-avoid-future-delayed
      Future.delayed(Duration.zero);
    });

    test('''.
      ## When: 
      - some method should be called
      ''', () async {
      // When
      // expect_lint: test-avoid-future-delayed
      await Future.delayed(Duration.zero);
    });
  });
}
