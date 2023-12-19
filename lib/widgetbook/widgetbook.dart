import 'package:concordium_wallet/design_system/ccd_theme.dart';
import 'package:concordium_wallet/widgetbook/components/component_folder.dart';
import 'package:concordium_wallet/widgetbook/foundation/foundation_folder.dart';
import 'package:concordium_wallet/widgetbook/helpers/ccd_widgetbook_theme.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

void main() {
  runApp(const WidgetbookApp());
}

class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      addons: [
        _buildThemeAddon(),
        AlignmentAddon(),
      ],
      directories: [
        FoundationFolder(),
        ComponentFolder(),
      ],
    );
  }

  ThemeAddon<CcdTheme> _buildThemeAddon() {
    return ThemeAddon<CcdTheme>(
      themes: [
        WidgetbookTheme(name: 'Light', data: CcdThemeLight()),
        WidgetbookTheme(name: 'Dark', data: CcdThemeDark()),
      ],
      themeBuilder: (_, theme, child) {
        return Theme(
          data: switch (theme.mode) {
            CcdThemeMode.dark => ThemeData.dark(),
            CcdThemeMode.light => ThemeData.light(),
          },
          child: CcdWidgetbookTheme(
            data: theme,
            child: child,
          ),
        );
      },
    );
  }
}
