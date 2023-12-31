import 'flutter_defines.dart';

class MyWidget extends StatelessWidget {
  Widget build(BuildContext _) => Column(children: [
        Container(
          // expect_lint: prefer-correct-edge-insets-constructor
          padding: const EdgeInsets.only(
            top: 10,
            left: 5,
            bottom: 10,
            right: 5,
          ),
        ),
        Container(
          padding:
              // expect_lint: prefer-correct-edge-insets-constructor
              const EdgeInsets.only(bottom: 10, right: 10, left: 10, top: 10),
        ),
        Container(
          padding:
              // expect_lint: prefer-correct-edge-insets-constructor
              const EdgeInsets.only(bottom: 10, right: 12, left: 12, top: 10),
        ),
        Container(
          // expect_lint: prefer-correct-edge-insets-constructor
          padding: const EdgeInsets.only(bottom: 10, top: 10),
        ),
        Container(
          // expect_lint: prefer-correct-edge-insets-constructor
          padding: const EdgeInsets.only(left: 10, right: 10),
        ),
        Container(
          // expect_lint: prefer-correct-edge-insets-constructor
          padding: const EdgeInsets.only(
            top: 10,
            left: 5,
            bottom: 10,
            right: 5,
          ),
        ),
        Container(
          // expect_lint: prefer-correct-edge-insets-constructor
          padding: const EdgeInsets.only(
            bottom: 10.0,
            right: 10.0,
            left: 10.0,
            top: 10.0,
          ),
        ),
        Container(
          // expect_lint: prefer-correct-edge-insets-constructor
          padding: const EdgeInsets.only(
            bottom: 10.0,
            right: 12.0,
            left: 12.0,
            top: 10.0,
          ),
        ),
        Container(
          // expect_lint: prefer-correct-edge-insets-constructor
          padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
        ),
        Container(
          // expect_lint: prefer-correct-edge-insets-constructor
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        ),
        Container(
          padding: const EdgeInsets.only(left: 10.0, right: 4.0),
        ),
        Container(
          padding: const EdgeInsets.only(
            left: 10.0,
            right: 4.0,
            top: 1.0,
            bottom: 11.0,
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 10.0),
        ),
        Container(
          padding: EdgeInsets.only(left: mockBool ? 70 : 0),
        ),
        Container(
          padding: EdgeInsets.only(right: spacing),
        ),
        Container(
          padding: EdgeInsets.only(left: 24.0 + spacing),
        ),
        Container(
          padding: EdgeInsets.only(
            top: spacing,
            bottom: spacing,
            left: 6.0,
            right: 6.0,
          ),
        ),
      ]);
}

final mockBool = false;
final spacing = 10.0;
