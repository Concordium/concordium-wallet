import 'package:concordium_wallet/design_system/foundation/colors/color_container.dart';
import 'package:concordium_wallet/design_system/foundation/colors/color_icon.dart';
import 'package:concordium_wallet/design_system/foundation/colors/color_layer.dart';
import 'package:concordium_wallet/design_system/foundation/colors/color_text.dart';
import 'package:concordium_wallet/design_system/foundation/typography/ccd_typography.dart';
import 'package:concordium_wallet/design_system/graphics/icons/icon_container.dart';
import 'package:flutter/material.dart';

enum CcdThemeMode { light, dark }

/// Convenience getter to allow us to get the CcdTheme via `context.theme`
/// instead of `CcdTheme.of(context)`
extension ThemeGetter on BuildContext {
  CcdTheme get theme => CcdTheme.of(this);
}

/// Defines the theme in accordance with the Figma design system
///
/// The theme is intended to be a 1:1 representation of the design system,
/// which means that both the structure and naming should be consistent with the design system.
abstract class CcdTheme extends ThemeExtension<CcdTheme> {
  final CcdTypography typography = CcdTypography();
  final IconContainer icon = IconContainer();
  late ColorContainer color;
  late CcdThemeMode mode;

  /// Gets the theme
  ///
  /// In order for this to work, the theme (or rather the specific themed subclasses) must have been registered beforehand as a theme extension.
  /// Otherwise, a [MissingCcdThemeError] is thrown
  ///
  /// Here's how to register the light theme as an extension:
  /// ```dart
  ///   ThemeState(ThemeData.light().copyWith(extensions: [ CcdThemeLight() ])
  /// ```
  ///
  static CcdTheme of(BuildContext context) {
    final theme = Theme.of(context).extension<CcdTheme>();
    if (theme == null) {
      throw MissingCcdThemeError();
    }
    return theme;
  }
}

class CcdThemeDark extends CcdTheme {
  CcdThemeDark() {
    color = ColorContainer(
      icon: ColorIconDark(),
      text: ColorTextDark(),
      layer: ColorLayerDark(),
    );
    mode = CcdThemeMode.dark;
  }

  @override
  ThemeExtension<CcdTheme> copyWith() {
    return CcdThemeDark();
  }

  @override
  ThemeExtension<CcdTheme> lerp(covariant ThemeExtension<CcdTheme>? other, double t) {
    if (other is! CcdThemeDark) {
      return this;
    }
    return CcdThemeDark();
  }
}

class CcdThemeLight extends CcdTheme {
  CcdThemeLight() {
    color = ColorContainer(
      icon: ColorIconLight(),
      text: ColorTextLight(),
      layer: ColorLayerLight(),
    );
    mode = CcdThemeMode.light;
  }

  @override
  ThemeExtension<CcdTheme> copyWith() {
    return CcdThemeLight();
  }

  @override
  ThemeExtension<CcdTheme> lerp(covariant ThemeExtension<CcdTheme>? other, double t) {
    if (other is! CcdThemeLight) {
      return this;
    }
    return CcdThemeLight();
  }
}

class MissingCcdThemeError extends Error {}
