import 'package:concordium_wallet/designsystem/theme/AppPalette.dart';
import 'package:concordium_wallet/designsystem/theme/AppTypography.dart';
import 'package:flutter/material.dart';

import 'AppColorsExtension.dart';
import 'AppTextThemeExtension.dart';

class ThemeState {
  final ThemeData themeData;

  ThemeState(this.themeData);

  static ThemeState get darkTheme => ThemeState(ThemeData.dark().copyWith(
        extensions: [_darkAppColors, _darkTextTheme],
      ));

  static ThemeState get lightTheme => ThemeState(ThemeData.light().copyWith(
        extensions: [
          _lightAppColors,
          _lightTextTheme,
        ],
      ));

  static final _lightAppColors = AppColorsExtension(
    primary: AppPalette.primaryMineralBlue,
    onPrimary: AppPalette.neutralWhite,
    secondary: AppPalette.secondaryDarkBlue,
    onSecondary: AppPalette.neutralBlack,
    error: AppPalette.negativeBase,
    onError: AppPalette.neutralWhite,
    background: AppPalette.neutralWhite,
    onBackground: AppPalette.neutralBlack,
    surface: AppPalette.neutralWhite,
    onSurface: AppPalette.neutralBlack,
  );

  static final _darkAppColors = AppColorsExtension(
    primary: AppPalette.darkModeMidnight,
    onPrimary: AppPalette.neutralBlack,
    secondary: AppPalette.secondaryDarkBlue,
    onSecondary: AppPalette.neutralBlack,
    error: AppPalette.negativeBase,
    onError: AppPalette.neutralBlack,
    background: AppPalette.darkModeMidnightDark,
    onBackground: AppPalette.neutralWhite,
    surface: AppPalette.darkModeMidnightDark,
    onSurface: AppPalette.neutralWhite,
  );

  static final _lightTextTheme = AppTextThemeExtension(
    displayLarge: AppTypography.display1.copyWith(color: Colors.black),
    displayMedium: AppTypography.display2.copyWith(color: Colors.black),
    displaySmall: AppTypography.display3.copyWith(color: Colors.black),
    headlineLarge: AppTypography.heading1.copyWith(color: Colors.black),
    headlineMedium: AppTypography.heading2.copyWith(color: Colors.black),
    headlineSmall: AppTypography.heading3.copyWith(color: Colors.black),
    titleLarge: AppTypography.heading4.copyWith(color: Colors.black),
    titleMedium: AppTypography.heading5.copyWith(color: Colors.black),
    titleSmall: AppTypography.heading6.copyWith(color: Colors.black),
    bodyLarge: AppTypography.bodyLightL.copyWith(color: Colors.black),
    bodyMedium: AppTypography.bodyLightM.copyWith(color: Colors.black),
    bodySmall: AppTypography.bodyLightS.copyWith(color: Colors.black),
    labelLarge: AppTypography.button.copyWith(color: Colors.black),
  );

  static final _darkTextTheme = AppTextThemeExtension(
    displayLarge: AppTypography.display1.copyWith(color: Colors.white),
    displayMedium: AppTypography.display2.copyWith(color: Colors.white),
    displaySmall: AppTypography.display3.copyWith(color: Colors.white),
    headlineLarge: AppTypography.heading1.copyWith(color: Colors.white),
    headlineMedium: AppTypography.heading2.copyWith(color: Colors.white),
    headlineSmall: AppTypography.heading3.copyWith(color: Colors.white),
    titleLarge: AppTypography.heading4.copyWith(color: Colors.white),
    titleMedium: AppTypography.heading5.copyWith(color: Colors.white),
    titleSmall: AppTypography.heading6.copyWith(color: Colors.white),
    bodyLarge: AppTypography.bodyLightL.copyWith(color: Colors.white),
    bodyMedium: AppTypography.bodyLightM.copyWith(color: Colors.white),
    bodySmall: AppTypography.bodyLightS.copyWith(color: Colors.white),
    labelLarge: AppTypography.button.copyWith(color: Colors.white),
  );
}

extension AppThemeExtension on ThemeData {
  AppColorsExtension get appColors =>
      extension<AppColorsExtension>() ?? ThemeState._lightAppColors;

  AppTextThemeExtension get appTextTheme =>
      extension<AppTextThemeExtension>() ?? ThemeState._lightTextTheme;
}

extension ThemeGetter on BuildContext {
  ThemeData get theme => Theme.of(this);
}
