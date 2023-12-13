import 'dart:ui';

import 'package:concordium_wallet/design_system/foundation/typography/ccd_font_family.dart';

class CcdTypography {
  //region Display
  TextStyle display1({required Color color}) =>
      makeDisplay(color: color, fontSize: 40, lineHeight: 47);

  TextStyle display2({required Color color}) =>
      makeDisplay(color: color, fontSize: 32, lineHeight: 36);

  TextStyle display3({required Color color}) =>
      makeDisplay(color: color, fontSize: 25, lineHeight: 30);

  TextStyle display4({required Color color}) =>
      makeDisplay(color: color, fontSize: 20, lineHeight: 24);

  TextStyle display5({required Color color}) =>
      makeDisplay(color: color, fontSize: 16, lineHeight: 19);

  TextStyle display6({required Color color}) =>
      makeDisplay(color: color, fontSize: 14, lineHeight: 17);

  TextStyle makeDisplay(
          {required Color color,
          required double fontSize,
          required double lineHeight}) =>
      TextStyle(
          color: color,
          fontSize: fontSize,
          height: lineHeight / fontSize,
          fontWeight: FontWeight.w700,
          fontFamily: CcdFontFamily.bold.name);
//endregion
}
