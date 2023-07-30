import 'flutter_defines.dart';

class MyWidget extends StatelessWidget {
  Widget build(BuildContext _) => Column(children: [
        Container(
          padding:
              // expect_lint: prefer-correct-edge-insets-constructor
              const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        ),
        Container(
          padding:
              // expect_lint: prefer-correct-edge-insets-constructor
              const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        ),
        Container(
          padding:
              // expect_lint: prefer-correct-edge-insets-constructor
              const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        ),
        Container(
          // expect_lint: prefer-correct-edge-insets-constructor
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        ),
        Container(
          // expect_lint: prefer-correct-edge-insets-constructor
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
        ),
        Container(
          // expect_lint: prefer-correct-edge-insets-constructor
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 2),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 2),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
        ),
      ]);
}
