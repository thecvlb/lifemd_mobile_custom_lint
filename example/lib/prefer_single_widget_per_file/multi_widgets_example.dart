// ignore_for_file: unused_element

import 'flutter_defines.dart';

class ExampleWidget extends StatelessWidget {
  Widget build(BuildContext context) => Widget();
}

class _PrivateWidget extends StatelessWidget {
  Widget build(BuildContext context) => Widget();
}

class _AnotherPrivateWidget extends StatefulWidget {
  _SomeStatefulWidgetState createState() => _SomeStatefulWidgetState();
}

class _SomeStatefulWidgetState extends State<_AnotherPrivateWidget> {
  Widget build(BuildContext context) => Widget();
}
