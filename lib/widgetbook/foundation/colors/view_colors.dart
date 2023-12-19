import 'package:concordium_wallet/design_system/ccd_theme.dart';
import 'package:concordium_wallet/design_system/foundation/colors/internal_color.dart';
import 'package:concordium_wallet/design_system/foundation/spacing/ccd_spacing.dart';
import 'package:concordium_wallet/widgetbook/helpers/ccd_widgetbook_theme.dart';
import 'package:concordium_wallet/widgetbook/helpers/default_component.dart';
import 'package:flutter/material.dart';

class ViewColors extends DefaultComponent {
  ViewColors() : super(name: 'Colors');

  @override
  Widget buildDefault(BuildContext context) {
    final theme = context.widgetBookTheme;

    return Container(
        padding: const EdgeInsets.all(CcdSpacing.pt16),
        color: theme.color.layer.layer01,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            // TODO(RHA): Replace with semantic color tokens
            buildColorRow(theme, InternalColor.mineralBlue, 'Mineral Blue'),
            buildColorRow(theme, InternalColor.mineralBlue80, 'Mineral 80'),
            buildColorRow(theme, InternalColor.mineralBlue60, 'Mineral 60'),
          ],
        ));
  }

  Widget buildColorRow(CcdTheme theme, Color color, String name) => Padding(
        padding: const EdgeInsets.only(bottom: CcdSpacing.pt8),
        child: Row(
          children: [
            Container(color: color, width: 50.0, height: 50.0),
            const SizedBox(width: CcdSpacing.pt16),
            Text(name, style: theme.typography.heading1(color: theme.color.text.primary)),
          ],
        ),
      );
}
