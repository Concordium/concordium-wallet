import 'package:concordium_wallet/design_system/ccd_theme.dart';
import 'package:concordium_wallet/design_system/foundation/colors/internal_color.dart';
import 'package:concordium_wallet/design_system/foundation/spacing/ccd_spacing.dart';
import 'package:concordium_wallet/widgetbook/helpers/ccd_widgetbook_theme.dart';
import 'package:concordium_wallet/widgetbook/helpers/default_component.dart';
import 'package:flutter/material.dart';

class ViewTypography extends DefaultComponent {
  ViewTypography() : super(name: 'Typography');

  static const _spacing = SizedBox(
    height: CcdSpacing.pt16,
  );

  @override
  Widget buildDefault(BuildContext context) {
    final theme = context.widgetBookTheme;
    final color = theme.color.text.primary;

    return Container(
        padding: const EdgeInsets.all(CcdSpacing.pt16),
        color: theme.color.layer.layer01,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            ...buildHeading(theme, color),
            ...buildBody(theme, color),
            ...buildBodyLight(theme, color),
            ...buildButton(theme, color),
          ],
        ));
  }

  List<Widget> buildHeading(CcdTheme theme, Color color) => [
        buildTypographyRow(theme.typography.heading1(color: color), 'Heading 1'),
        buildTypographyRow(theme.typography.heading2(color: color), 'Heading 2'),
        buildTypographyRow(theme.typography.heading3(color: color), 'Heading 3'),
        buildTypographyRow(theme.typography.heading4(color: color), 'Heading 4'),
        buildTypographyRow(theme.typography.heading5(color: color), 'Heading 5'),
        buildTypographyRow(theme.typography.heading6(color: color), 'Heading 6'),
        buildTypographyRow(theme.typography.heading7(color: color), 'Heading 7'),
        _spacing,
      ];

  List<Widget> buildBody(CcdTheme theme, Color color) => [
        buildTypographyRow(theme.typography.bodyXL(color: color), 'Body XL'),
        buildTypographyRow(theme.typography.bodyL(color: color), 'Body L'),
        buildTypographyRow(theme.typography.bodyM(color: color), 'Body M'),
        buildTypographyRow(theme.typography.bodyS(color: color), 'Body S'),
        buildTypographyRow(theme.typography.bodyXS(color: color), 'Body XS'),
        _spacing,
      ];

  List<Widget> buildBodyLight(CcdTheme theme, Color color) => [
        buildTypographyRow(theme.typography.bodyLightXL(color: color), 'Body Light XL'),
        buildTypographyRow(theme.typography.bodyLightL(color: color), 'Body Light L'),
        buildTypographyRow(theme.typography.bodyLightM(color: color), 'Body Light M'),
        buildTypographyRow(theme.typography.bodyLightS(color: color), 'Body Light S'),
        buildTypographyRow(theme.typography.bodyLightXS(color: color), 'Body Light XS'),
        _spacing,
      ];

  List<Widget> buildButton(CcdTheme theme, Color color) => [
        buildTypographyRow(theme.typography.button(color: color), 'Button'),
        _spacing,
      ];

  Widget buildTypographyRow(TextStyle style, String name) => Padding(
        padding: const EdgeInsets.only(bottom: CcdSpacing.pt8),
        child: Text('$name: The quick brown fox jumped over the lazy dog', style: style),
      );
}
