// This is the entrypoint of our custom linter
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:lifemd_mobile_custom_lint/rules/equtable_public_property_documentation.dart';

import 'rules/avoid_top_level_members_in_tests.dart';
import 'rules/controller_public_member_documentation.dart';
import 'rules/controller_public_method_name.dart';
import 'rules/list_all_equatable_fields.dart';
import 'rules/prefer_correct_test_file_name.dart';
import 'rules/prefer_single_widget_per_file.dart';

PluginBase createPlugin() => _MobileCustomLinter();

/// A plugin class is used to list all the assists/lints defined by a plugin.
class _MobileCustomLinter extends PluginBase {
  /// We list all the custom warnings/infos/errors
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        ControllerPublicMethodName(),
        ControllerPublicMemberDocumentation(),
        EquatablePublicPropertyDocumentation(),
        // ControllerPublicMutableProperty(),
        PreferSingleWidgetPerFile(),
        PreferCorrectTestFileName(),
        ListAllEquatableFields(),
        AvoidTopLevelMembersInTests(),
      ];
}
