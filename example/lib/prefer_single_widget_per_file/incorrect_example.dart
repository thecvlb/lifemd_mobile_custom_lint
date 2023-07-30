// ignore_for_file: unused_element

import 'flutter_defines.dart';

// expect_lint: prefer-single-widget-per-file
class SomeWidget extends StatelessWidget {
  Widget build(BuildContext context) => Widget();
}

// expect_lint: prefer-single-widget-per-file
class SomeOtherWidget extends StatelessWidget {
  Widget build(BuildContext context) => Widget();
}

class _SomeOtherWidget extends StatelessWidget {
  Widget build(BuildContext context) => Widget();
}

// expect_lint: prefer-single-widget-per-file
class SomeStatefulWidget extends StatefulWidget {
  _SomeStatefulWidgetState createState() => _SomeStatefulWidgetState();
}

class _SomeStatefulWidgetState extends State<SomeStatefulWidget> {
  Widget build(BuildContext context) => Widget();
}
