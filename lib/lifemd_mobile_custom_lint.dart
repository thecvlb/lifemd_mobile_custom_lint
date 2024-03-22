// This is the entrypoint of our custom linter
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'rules/avoid_expanded_as_spacer/avoid_expanded_as_spacer.dart';
import 'rules/avoid_print_and_get_log/avoid_print_and_get_log.dart';
import 'rules/avoid_single_child_in_row_and_column/avoid_single_child_in_row_and_column.dart';
import 'rules/avoid_top_level_members_in_tests/avoid_top_level_members_in_tests.dart';
import 'rules/class_member_order/class_member_order.dart';
import 'rules/controller_public_member_documentation/controller_public_member_documentation.dart';
import 'rules/controller_public_method_name/controller_public_method_name.dart';
import 'rules/controller_public_mutable_property/controller_public_mutable_property.dart';
import 'rules/equtable_public_property_documentation/equtable_public_property_documentation.dart';
import 'rules/list_all_equatable_fields/list_all_equatable_fields.dart';
import 'rules/prefer_correct_edge_insets_constructor/prefer_correct_edge_insets_constructor.dart';
import 'rules/prefer_correct_file_name/prefer_correct_file_name.dart';
import 'rules/prefer_correct_test_file_name/prefer_correct_test_file_name.dart';
import 'rules/prefer_single_widget_per_file/prefer_single_widget_per_file.dart';
import 'rules/test_avoid_future_delayed/test_avoid_future_delayed.dart';
import 'rules/test_body_sections/test_body_sections.dart';
import 'rules/test_body_verify_methods/test_body_verify_methods.dart';
import 'rules/test_description_format/test_description_format.dart';
import 'rules/test_description_section_name/test_description_section_name.dart';
import 'rules/test_description_sections/test_description_sections.dart';
import 'rules/test_description_single_when_action/test_description_single_when_action.dart';
import 'rules/test_description_then_avoid_some/test_description_then_avoid_some.dart';
import 'rules/test_description_then_should/test_description_then_should.dart';

PluginBase createPlugin() => _MobileCustomLinter();

/// A plugin class is used to list all the assists/lints defined by a plugin.
class _MobileCustomLinter extends PluginBase {
  /// We list all the custom warnings/infos/errors
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        AvoidExpandedAsSpacer(),
        AvoidPrintAndGetLog(),
        AvoidSingleChildInRowAndColumn(),
        AvoidTopLevelMembersInTests(),
        ClassMemberOrder(),
        ControllerPublicMemberDocumentation(),
        ControllerPublicMethodName(),
        ControllerPublicMutableProperty(),
        EquatablePublicPropertyDocumentation(),
        ListAllEquatableFields(),
        PreferCorrectEdgeInsetsConstructor(),
        PreferCorrectFileName(),
        PreferCorrectTestFileName(),
        PreferSingleWidgetPerFile(),
        TestAvoidFutureDelayed(),
        TestBodySections(),
        TestBodyVerifyMethods(),
        TestDescriptionFormat(),
        TestDescriptionSectionName(),
        TestDescriptionSingleWhenAction(),
        TestDescriptionThenAvoidSome(),
        TestDescriptionThenShould(),
        TestDescriptionSections(),
      ];
}
