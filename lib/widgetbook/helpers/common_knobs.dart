import 'package:concordium_wallet/design_system/ccd_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:widgetbook/widgetbook.dart';

mixin CommonKnobs {
  Widget themeKnob(BuildContext context) =>
      context.knobs.list(label: 'Theme', options: [
        ThemeWidget(theme: CcdThemeLight()),
        ThemeWidget(theme: CcdThemeDark())
      ]);
}

class ThemeWidget extends StatelessWidget {
  final CcdTheme theme;

  const ThemeWidget({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }

}