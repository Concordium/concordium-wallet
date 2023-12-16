import 'package:concordium_wallet/design_system/ccd_theme.dart';
import 'package:concordium_wallet/design_system/foundation/spacing/ccd_spacing.dart';
import 'package:concordium_wallet/design_system/graphics/icons/ccd_icon.dart';
import 'package:concordium_wallet/design_system/graphics/icons/icon_container.dart';
import 'package:concordium_wallet/design_system/graphics/icons/icon_size.dart';
import 'package:concordium_wallet/widgetbook/helpers/default_component.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

class ViewIcons extends DefaultComponent {
  ViewIcons() : super(name: 'Icons');

  @override
  Widget buildDefault(BuildContext context) => buildIconsList(context, CcdTheme.of(context));

  Widget buildIconsList(BuildContext context, CcdTheme theme) {
    return Padding(
        padding: const EdgeInsets.all(CcdSpacing.pt16),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [for (final icon in allIcons(theme)) _buildIconWithName(theme, icon)],
        ));
  }

  List<CcdIcon> allIcons(CcdTheme theme) {
    const size = IconSize.pt30;
    final color = theme.color.icon.primary;
    final icon = theme.icon;
    return [
      icon.accordionOpen(size: size, color: color),
      icon.add(size: size, color: color),
      icon.arrowLeft(size: size, color: color),
      icon.cancel(size: size, color: color),
    ];
  }

  static Widget _buildIconWithName(CcdTheme theme, CcdIcon icon) {
    return Column(
      children: [
        Row(children: [
          icon,
          const SizedBox(width: CcdSpacing.pt16),
          Text(icon.shortName, style: theme.typography.display1(color: theme.color.text.primary)),
        ]),
        const Divider(),
      ],
    );
  }
}
