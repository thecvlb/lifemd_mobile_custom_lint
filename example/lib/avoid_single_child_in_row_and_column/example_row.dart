// ignore_for_file: prefer-single-widget-per-file
import 'flutter_defines.dart';

class SingleChildRowWidget extends StatelessWidget {
  // expect_lint: avoid-single-child-in-row-and-column
  Widget build(BuildContext _) => Row(
        children: [
          Widget(),
        ],
      );
}

class MultiChildrenRowWidget extends StatelessWidget {
  Widget build(BuildContext _) => Row(
        children: [
          Widget(),
          Widget(),
        ],
      );
}
