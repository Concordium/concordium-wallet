import 'package:concordium_wallet/design_system/ccd_theme.dart';
import 'package:concordium_wallet/design_system/foundation/colors/internal_color.dart';
import 'package:concordium_wallet/design_system/foundation/spacing/ccd_spacing.dart';
import 'package:concordium_wallet/widgetbook/helpers/ccd_widgetbook_theme.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

class ViewInternalColors {
  WidgetbookComponent get component => WidgetbookComponent(name: 'Internal colors', useCases: [
        primary,
        secondary,
        darkMode,
      ]);

  WidgetbookUseCase get primary => WidgetbookUseCase(
      name: 'Primary',
      builder: (context) {
        final theme = context.widgetBookTheme;
        return buildColors(context, [
          buildColorRow(theme, InternalColor.mineralBlue, 'Mineral Blue'),
          buildColorRow(theme, InternalColor.mineral80, 'Mineral 80'),
          buildColorRow(theme, InternalColor.mineral60, 'Mineral 60'),
          buildColorRow(theme, InternalColor.mineralBlue, 'Mineral 40'),
          buildColorRow(theme, InternalColor.mineral80, 'Mineral 20'),
          buildColorRow(theme, InternalColor.mineral60, 'Mineral 10'),
          buildColorRow(theme, InternalColor.mineral60, 'Mineral 05'),
        ]);
      });

  WidgetbookUseCase get secondary => WidgetbookUseCase(
      name: 'Secondary',
      builder: (context) {
        final theme = context.widgetBookTheme;
        return buildColors(context, [
          buildColorRow(theme, InternalColor.darkBlue, 'Dark Blue'),
          buildColorRow(theme, InternalColor.ocean140, 'Ocean 140'),
          buildColorRow(theme, InternalColor.ocean120, 'Ocean 120'),
          buildColorRow(theme, InternalColor.oceanBlue, 'Ocean Blue'),
          buildColorRow(theme, InternalColor.ocean60, 'Ocean 60'),
          buildColorRow(theme, InternalColor.eggShellWhite, 'Egg Shell White'),
          buildColorRow(theme, InternalColor.offWhite, 'Off White'),
        ]);
      });

  WidgetbookUseCase get neutral => WidgetbookUseCase(
      name: 'Neutral',
      builder: (context) {
        final theme = context.widgetBookTheme;
        return buildColors(context, [
          buildColorRow(theme, InternalColor.black, 'Black'),
          buildColorRow(theme, InternalColor.black90, 'Black 90'),
          buildColorRow(theme, InternalColor.black80, 'Black 80'),
          buildColorRow(theme, InternalColor.black70, 'Black 70'),
          buildColorRow(theme, InternalColor.black60, 'Black 60'),
          buildColorRow(theme, InternalColor.black50, 'Black 50'),
          buildColorRow(theme, InternalColor.black40, 'Black 40'),
        ]);
      });

  WidgetbookUseCase get darkMode => WidgetbookUseCase(
      name: 'Dark Mode',
      builder: (context) {
        final theme = context.widgetBookTheme;
        return buildColors(context, [
          buildColorRow(theme, InternalColor.midnightDark, 'Midnight Dark'),
          buildColorRow(theme, InternalColor.midnight, 'Midnight'),
          buildColorRow(theme, InternalColor.midnightLight, 'Midnight Light'),
        ]);
      });

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
