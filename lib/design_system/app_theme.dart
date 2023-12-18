import 'package:concordium_wallet/design_system/ccd_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeState {
  final ThemeData themeData;

  ThemeState(this.themeData);

  static ThemeState get darkTheme => ThemeState(ThemeData.dark().copyWith(extensions: [
        CcdThemeDark(),
      ]));

  static ThemeState get lightTheme => ThemeState(ThemeData.light().copyWith(extensions: [
        CcdThemeLight(),
      ]));
}

class AppTheme extends Cubit<ThemeState> {
  AppTheme() : super(ThemeState.lightTheme);

  void setTheme(CcdThemeMode mode) => switch (mode) {
        CcdThemeMode.light => emit(ThemeState.lightTheme),
        CcdThemeMode.dark => emit(ThemeState.darkTheme),
      };
}
