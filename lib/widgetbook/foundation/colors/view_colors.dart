import 'package:concordium_wallet/design_system/foundation/spacing/ccd_spacing.dart';
import 'package:concordium_wallet/widgetbook/foundation/colors/color_builder_helper.dart';
import 'package:concordium_wallet/widgetbook/helpers/ccd_widgetbook_theme.dart';
import 'package:concordium_wallet/widgetbook/helpers/default_component.dart';
import 'package:flutter/material.dart';

class ViewColors extends DefaultComponent with ColorBuilderHelper {
  ViewColors() : super(name: 'Colors');

  @override
  Widget buildDefault(BuildContext context) {
    final theme = context.widgetBookTheme;

    return buildColors(context, [
      buildColorRow(theme, Colors.black, 'Placeholder - missing semantic color tokens')
    ]);
  }
}
