import 'package:concordium_wallet/design_system/ccd_theme.dart';
import 'package:concordium_wallet/design_system/foundation/spacing/ccd_spacing.dart';
import 'package:concordium_wallet/widgetbook/helpers/ccd_widgetbook_theme.dart';
import 'package:flutter/widgets.dart';

mixin ColorBuilderHelper {
  Widget buildColors(BuildContext context, List<Widget> colors) {
    final theme = context.widgetBookTheme;

    return Container(
        padding: const EdgeInsets.all(CcdSpacing.pt16),
        color: theme.color.layer.layer01,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            ...colors,
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
