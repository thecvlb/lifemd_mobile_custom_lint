// ignore_for_file: prefer-single-widget-per-file
import 'flutter_defines.dart';

class SingleChildColumnWidget extends StatelessWidget {
  // expect_lint: avoid-single-child-in-row-and-column
  Widget build(BuildContext _) => Column(
        children: [
          Widget(),
        ],
      );
}

class MultiChildrenColumnWidget extends StatelessWidget {
  Widget build(BuildContext _) => Column(
        children: [
          Widget(),
          Widget(),
        ],
      );
}
