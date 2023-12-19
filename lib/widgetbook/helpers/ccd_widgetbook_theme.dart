import 'package:concordium_wallet/design_system/ccd_theme.dart';
import 'package:flutter/widgets.dart';

class CcdWidgetbookTheme extends InheritedWidget {
  const CcdWidgetbookTheme({
    super.key,
    required this.data,
    required super.child,
  });

  final CcdTheme data;

  static CcdTheme of(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<CcdWidgetbookTheme>();
    return widget!.data;
  }

  @override
  bool updateShouldNotify(covariant CcdWidgetbookTheme oldWidget) {
    return data != oldWidget.data;
  }
}
