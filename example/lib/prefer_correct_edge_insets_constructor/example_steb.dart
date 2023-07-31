import 'flutter_defines.dart';

class MyWidget extends StatelessWidget {
  Widget build(BuildContext _) => Column(children: [
        Container(
          // expect_lint: prefer-correct-edge-insets-constructor
          padding: const EdgeInsetsDirectional.fromSTEB(1, 1, 0, 0),
        ),
        Container(
          // expect_lint: prefer-correct-edge-insets-constructor
          padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
        ),
        Container(
          // expect_lint: prefer-correct-edge-insets-constructor
          padding: const EdgeInsetsDirectional.fromSTEB(1, 1, 1, 1),
        ),
        Container(
          // expect_lint: prefer-correct-edge-insets-constructor
          padding: const EdgeInsetsDirectional.fromSTEB(3, 2, 3, 2),
        ),
        Container(
          // expect_lint: prefer-correct-edge-insets-constructor
          padding: const EdgeInsetsDirectional.fromSTEB(3, 0, 0, 2),
        ),
        Container(
          padding: EdgeInsetsDirectional.fromSTEB(3, _test, 2 - 2, test()),
        ),
        Container(
          padding:
              // expect_lint: prefer-correct-edge-insets-constructor
              const EdgeInsetsDirectional.fromSTEB(1.0, 1.0, 0.0, 0.0),
        ),
        Container(
          // expect_lint: prefer-correct-edge-insets-constructor
          padding: const EdgeInsetsDirectional.fromSTEB(
            12.0,
            12.0,
            12.0,
            12.0,
          ),
        ),
        Container(
          padding:
              // expect_lint: prefer-correct-edge-insets-constructor
              const EdgeInsetsDirectional.fromSTEB(1.0, 1.0, 1.0, 1.0),
        ),
        Container(
          padding:
              // expect_lint: prefer-correct-edge-insets-constructor
              const EdgeInsetsDirectional.fromSTEB(3.0, 2.0, 3.0, 2.0),
        ),
        Container(
          padding:
              // expect_lint: prefer-correct-edge-insets-constructor
              const EdgeInsetsDirectional.fromSTEB(3.0, 0.0, 0.0, 2.0),
        ),
        Container(
          padding: EdgeInsetsDirectional.fromSTEB(3.0, _test, 2 - 2, test()),
        ),
        Container(
          // expect_lint: prefer-correct-edge-insets-constructor
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
        ),
        Container(
          padding: EdgeInsetsDirectional.fromSTEB(3, 4, 5, 6),
        ),
        Container(
          padding: EdgeInsetsDirectional.fromSTEB(3, 4, 4, 6),
        ),
        Container(
          padding: EdgeInsetsDirectional.fromSTEB(6, 4, 5, 6),
        ),
      ]);
}

const _test = 0.0;

double test() => 0;
