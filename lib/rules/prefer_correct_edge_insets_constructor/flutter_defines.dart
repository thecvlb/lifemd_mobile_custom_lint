import 'package:meta/meta.dart';

@immutable
class EdgeInsetsParam {
  final String? name;
  final num? value;

  const EdgeInsetsParam({required this.value, this.name});
}

@immutable
class EdgeInsetsData {
  final String className;
  final String constructorName;
  final List<EdgeInsetsParam> params;

  const EdgeInsetsData(this.className, this.constructorName, this.params);
}
