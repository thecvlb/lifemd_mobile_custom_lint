// ignore_for_file: prefer-single-widget-per-file
class MyWidget extends StatelessWidget {
  Widget build(BuildContext context) => Column(children: [
        // expect_lint: avoid-expanded-as-spacer
        Expanded(child: Container()),
        // expect_lint: avoid-expanded-as-spacer
        Expanded(child: SizedBox()),
        Expanded(child: foo()),
        Expanded(child: SizedBox(child: Container())),
        Expanded(child: Container(child: SizedBox())),
        Spacer(),
      ]);
}

Widget foo() => SizedBox();

class Container extends Widget {
  final Widget? child;

  const Container({this.child});
}

class Expanded extends Widget {
  final Widget? child;

  const Expanded({this.child});
}

class SizedBox extends Widget {
  final Widget? child;

  const SizedBox({this.child});
}

class Spacer extends Widget {
  const Spacer();
}

class Column extends Widget {
  final List<Widget> children;

  const Column({required this.children});
}

class StatelessWidget extends Widget {}

class Widget {
  const Widget();
}

class BuildContext {}
