// ignore_for_file: test-body-verify-methods, test-body-sections
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('onInit', () {
    /// Proper format
    test('''.
      ## When:
      - some action called
      ## Then should: 
      - some method be called
      ''', () {});

    /// Proper format
    test(
      '''
      ## When:
      - some action called
        - param
      ## Then should: 
      - some method be called
      ''',
      () {},
    );

    /// line has wrong offset
    // expect_lint: test-description-format
    test('''
        ## When:
      - some action called
      ## Then should: 
      - some method called
      ''', () {});

    /// line has wrong offset: should be previous + 2
    // expect_lint: test-description-format
    test(
      '''
      ## When:
          - some action called
      ## Then should: 
      - some method be called
      ''',
      () {},
    );

    /// line has wrong offset: should be previous + 2
    // expect_lint: test-description-format
    test('''
      ## When:
          - some action called
      ## Then should: 
      - some method be called
      ''', () {});

    /// line has wrong offset: should be even
    // expect_lint: test-description-format
    test(
      '''
      ## Given:
        - some action called
          - param
          - param
       - some given state  
      ## Then should: 
      - some method be called
      ''',
      () {},
    );

    /// line has wrong offset: should be even
    // expect_lint: test-description-format
    test('''
      ## Given:
        - some action called
          - param
          - param
       - some given state  
      ## Then should: 
      - some method be called
      ''', () {});
  });
}
