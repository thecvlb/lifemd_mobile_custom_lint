Custom lint rules for mobile app

## custom_lint package

https://pub.dev/packages/custom_lint

## Rules ported from [Dart Code Metrics](https://docs.codeclimate.com/docs/dart-code-metrics)


- [avoid-expanded-as-spacer](https://dcm.dev/docs/rules/flutter/avoid-expanded-as-spacer/)
- [avoid-top-level-members-in-tests](https://dcm.dev/docs/rules/common/avoid-top-level-members-in-tests/)
- [list-all-equatable-fields](https://dcm.dev/docs/rules/equatable/list-all-equatable-fields/)
- [prefer-correct-edge-insets-constructor](https://dcm.dev/docs/rules/flutter/prefer-correct-edge-insets-constructor/)
- [prefer-correct-test-file-name](https://dcm.dev/docs/rules/common/prefer-correct-test-file-name/)
- [prefer-single-widget-per-file](https://dcm.dev/docs/rules/flutter/prefer-single-widget-per-file/)

## Custom Rules
- controller_public_member_documentation

  Check that public members of classes that extends `GetxController` , `GetxService` and `DisposableGetxService` have documentation comments

- controller_public_method_name

  Check that classes extends `GetxController` have public functions named like this:
    - `on<SomethingHappened>`

- controller_public_mutable_property

  Check that classes extends GetxController do not expose mutable properties and getters outside
    - `UnmodifiableRxView` should be used instead of `Rx`
    - `UnmodifiableListView` or `Iterable` should be used instead of `List`

- correct-test-description

    - Divided into three sections
        - `Given` (optional, but must be first)
        - `When` (required if there is no `Then` , should be second)
        - `Then` (required if there is no `When`, should be third)
    - `Then` section have `should` word

- equatable_public_property_documentation

  Check that classes extends `Equatable` have public properties with documentation
