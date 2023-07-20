// This is the entrypoint of our custom linter
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:lifemd_mobile_custom_lint/rules/controller_public_member_documentation.dart';
import 'package:lifemd_mobile_custom_lint/rules/controller_public_method_name.dart';

PluginBase createPlugin() => _MobileCustomLinter();

/// A plugin class is used to list all the assists/lints defined by a plugin.
class _MobileCustomLinter extends PluginBase {
  /// We list all the custom warnings/infos/errors
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        ControllerPublicMethodName(),
        ControllerPublicMemberDocumentation(),
      ];
}
