// ignore_for_file: prefer-single-widget-per-file
class Column extends Widget {
  final List<Widget> children;

  Column({required this.children});
}

class Row extends Widget {
  final List<Widget> children;

  Row({required this.children});
}

class Stack extends Widget {
  final List<Widget> children;

  Stack({required this.children});
}

class StatelessWidget extends Widget {}

class Widget {
  const Widget();
}

class BuildContext {}
