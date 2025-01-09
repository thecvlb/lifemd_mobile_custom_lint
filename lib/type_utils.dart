import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';

bool isWidgetOrSubclass(DartType? type) =>
    _isWidget(type) || _isSubclassOfWidget(type);

bool _isWidget(DartType? type) => type?.getDisplayString() == 'Widget';

bool _isSubclassOfWidget(DartType? type) =>
    type is InterfaceType && type.allSupertypes.any(_isWidget);

bool isControllerOrSubclass(DartType? type) =>
    _isController(type) || _isSubclassOfController(type);

bool _isSubclassOfController(DartType? type) =>
    type is InterfaceType && type.allSupertypes.any(_isController);

bool _isController(DartType? type) =>
    type?.getDisplayString() == 'GetxController';

bool isServiceOrSubclass(DartType? type) =>
    _isService(type) || _isSubclassOfService(type);

bool _isSubclassOfService(DartType? type) =>
    type is InterfaceType && type.allSupertypes.any(_isService);

bool _isService(DartType? type) => type?.getDisplayString() == 'GetxService';

bool isDisposableServiceOrSubclass(DartType? type) =>
    _isDisposableService(type) || _isSubclassOfDisposableService(type);

bool _isSubclassOfDisposableService(DartType? type) =>
    type is InterfaceType && type.allSupertypes.any(_isDisposableService);

bool _isDisposableService(DartType? type) =>
    type?.getDisplayString() == 'DisposableGetxService';

bool isEquatableOrSubclass(DartType? type) =>
    _isEquatable(type) || _isSubclassOfEquatable(type);

bool _isSubclassOfEquatable(DartType? type) =>
    type is InterfaceType && type.allSupertypes.any(_isEquatable);

bool _isEquatable(DartType? type) => type?.getDisplayString() == 'Equatable';

bool isEquatableMixin(DartType? type) =>
    type?.element is MixinElement &&
    type?.getDisplayString() == 'EquatableMixin';

bool isSubclassOfEquatableMixin(DartType? type) {
  final element = type?.element;

  return element is ClassElement && element.mixins.any(isEquatableMixin);
}
