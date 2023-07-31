import 'flutter_defines.dart';

class MyWidget extends StatelessWidget {
  Widget build(BuildContext _) => Column(children: [
        Container(
          // expect_lint: prefer-correct-edge-insets-constructor
          padding: const EdgeInsetsDirectional.only(
            top: 10,
            start: 5,
            bottom: 10,
            end: 5,
          ),
        ),
        Container(
          // expect_lint: prefer-correct-edge-insets-constructor
          padding: const EdgeInsetsDirectional.only(
              bottom: 10, end: 10, start: 10, top: 10),
        ),
        Container(
          // expect_lint: prefer-correct-edge-insets-constructor
          padding: const EdgeInsetsDirectional.only(
              bottom: 10, start: 12, end: 12, top: 10),
        ),
        Container(
          padding:
              // expect_lint: prefer-correct-edge-insets-constructor
              const EdgeInsetsDirectional.only(bottom: 10, top: 10),
        ),
        Container(
          // expect_lint: prefer-correct-edge-insets-constructor
          padding: const EdgeInsetsDirectional.only(start: 10, end: 10),
        ),
        Container(
          // expect_lint: prefer-correct-edge-insets-constructor
          padding: const EdgeInsetsDirectional.only(
            top: 10,
            start: 5,
            bottom: 10,
            end: 5,
          ),
        ),
        Container(
          // expect_lint: prefer-correct-edge-insets-constructor
          padding: const EdgeInsetsDirectional.only(
            bottom: 10.0,
            end: 10.0,
            start: 10.0,
            top: 10.0,
          ),
        ),
        Container(
          // expect_lint: prefer-correct-edge-insets-constructor
          padding: const EdgeInsetsDirectional.only(
            bottom: 10.0,
            start: 12.0,
            end: 12.0,
            top: 10.0,
          ),
        ),
        Container(
          padding:
              // expect_lint: prefer-correct-edge-insets-constructor
              const EdgeInsetsDirectional.only(bottom: 10.0, top: 10.0),
        ),
        Container(
          padding:
              // expect_lint: prefer-correct-edge-insets-constructor
              const EdgeInsetsDirectional.only(start: 10.0, end: 10.0),
        ),
        Container(
          padding: const EdgeInsetsDirectional.only(start: 10.0, end: 4.0),
        ),
        Container(
          padding: const EdgeInsetsDirectional.only(
            start: 10.0,
            end: 4.0,
            top: 1.0,
            bottom: 11.0,
          ),
        ),
        Container(
          padding: const EdgeInsetsDirectional.only(start: 10.0),
        ),
      ]);
}
