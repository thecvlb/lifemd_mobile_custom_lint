// ignore_for_file: prefer-single-widget-per-file
import 'flutter_defines.dart';

class SingleChildStackWidget extends StatelessWidget {
  // expect_lint: avoid-single-child-in-row-and-column
  Widget build(BuildContext _) => Stack(
        children: [
          Widget(),
        ],
      );
}

class MultiChildrenStackWidget extends StatelessWidget {
  Widget build(BuildContext _) => Stack(
        children: [
          Widget(),
          Widget(),
        ],
      );
}
