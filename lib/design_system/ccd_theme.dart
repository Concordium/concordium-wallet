import 'package:concordium_wallet/design_system/foundation/colors/color_container.dart';
import 'package:concordium_wallet/design_system/foundation/colors/color_icon.dart';
import 'package:concordium_wallet/design_system/foundation/colors/color_text.dart';
import 'package:concordium_wallet/design_system/foundation/typography/ccd_typography.dart';
import 'package:flutter/material.dart';

abstract class CcdTheme extends ThemeExtension<CcdTheme> {
  final CcdTypography typography = CcdTypography();
  late ColorContainer color;

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
    );
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
    );
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
