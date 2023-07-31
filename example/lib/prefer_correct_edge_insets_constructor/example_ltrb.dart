import 'flutter_defines.dart';

class MyWidget extends StatelessWidget {
  Widget build(BuildContext _) => Column(children: [
        Container(
          // expect_lint: prefer-correct-edge-insets-constructor
          padding: const EdgeInsets.fromLTRB(1, 1, 0, 0),
        ),
        Container(
          // expect_lint: prefer-correct-edge-insets-constructor
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        ),
        Container(
          // expect_lint: prefer-correct-edge-insets-constructor
          padding: const EdgeInsets.fromLTRB(1, 1, 1, 1),
        ),
        Container(
          // expect_lint: prefer-correct-edge-insets-constructor
          padding: const EdgeInsets.fromLTRB(3, 2, 3, 2),
        ),
        Container(
          // expect_lint: prefer-correct-edge-insets-constructor
          padding: const EdgeInsets.fromLTRB(3, 0, 0, 2),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(3, _test, 2 - 2, test()),
        ),
        Container(
          // expect_lint: prefer-correct-edge-insets-constructor
          padding: const EdgeInsets.fromLTRB(1.0, 1.0, 0.0, 0.0),
        ),
        Container(
          // expect_lint: prefer-correct-edge-insets-constructor
          padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0),
        ),
        Container(
          // expect_lint: prefer-correct-edge-insets-constructor
          padding: const EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 1.0),
        ),
        Container(
          // expect_lint: prefer-correct-edge-insets-constructor
          padding: const EdgeInsets.fromLTRB(3.0, 2.0, 3.0, 2.0),
        ),
        Container(
          // expect_lint: prefer-correct-edge-insets-constructor
          padding: const EdgeInsets.fromLTRB(3.0, 0.0, 0.0, 2.0),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(3.0, _test, 2 - 2, test()),
        ),
        Container(
          // expect_lint: prefer-correct-edge-insets-constructor
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(3, 4, 5, 6),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(3, 4, 4, 6),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(6, 4, 5, 6),
        ),
      ]);
}

const _test = 0.0;

double test() => 0;
