import 'package:flutter/material.dart';

/// Design system typography
///
/// Figma link: https://www.figma.com/file/AXkkkw8sIWE9IUfA5upaeN/New-Concordium-Design-System?type=design&node-id=88-68&mode=design&t=YaiOkFszZzHLPJGB-0
class CcdTypography with _Display, _Heading, _Body, _BodyLight, _Button {}

TextStyle _createStyle({required Color color, required double fontSize, required double lineHeight, required FontWeight fontWeight}) => TextStyle(
      color: color,
      fontSize: fontSize,
      height: lineHeight / fontSize,
      fontWeight: fontWeight,
      fontFamily: 'IBMPlexSans',
    );

mixin _Display {
  TextStyle display1({required Color color}) => _createDisplay(color: color, fontSize: 40, lineHeight: 47);

  TextStyle display2({required Color color}) => _createDisplay(color: color, fontSize: 32, lineHeight: 36);

  TextStyle display3({required Color color}) => _createDisplay(color: color, fontSize: 25, lineHeight: 30);

  TextStyle display4({required Color color}) => _createDisplay(color: color, fontSize: 20, lineHeight: 24);

  TextStyle display5({required Color color}) => _createDisplay(color: color, fontSize: 16, lineHeight: 19);

  TextStyle display6({required Color color}) => _createDisplay(color: color, fontSize: 14, lineHeight: 17);

  TextStyle _createDisplay({required Color color, required double fontSize, required double lineHeight}) =>
      _createStyle(color: color, fontSize: fontSize, lineHeight: lineHeight, fontWeight: FontWeight.w700);
}

mixin _Heading {
  TextStyle heading1({required Color color}) => _createHeading(color: color, fontSize: 28, lineHeight: 36);

  TextStyle heading2({required Color color}) => _createHeading(color: color, fontSize: 24, lineHeight: 32);

  TextStyle heading3({required Color color}) => _createHeading(color: color, fontSize: 20, lineHeight: 28);

  TextStyle heading4({required Color color}) => _createHeading(color: color, fontSize: 18, lineHeight: 26);

  TextStyle heading5({required Color color}) => _createHeading(color: color, fontSize: 16, lineHeight: 20);

  TextStyle heading6({required Color color}) => _createHeading(color: color, fontSize: 14, lineHeight: 18);

  TextStyle heading7({required Color color}) => _createHeading(color: color, fontSize: 12, lineHeight: 16);

  TextStyle _createHeading({required Color color, required double fontSize, required double lineHeight}) =>
      _createStyle(color: color, fontSize: fontSize, lineHeight: lineHeight, fontWeight: FontWeight.w500);
}

mixin _Body {
  TextStyle bodyXL({required Color color}) => _createBody(color: color, fontSize: 20, lineHeight: 26);

  TextStyle bodyL({required Color color}) => _createBody(color: color, fontSize: 16, lineHeight: 20);

  TextStyle bodyM({required Color color}) => _createBody(color: color, fontSize: 14, lineHeight: 18);

  TextStyle bodyS({required Color color}) => _createBody(color: color, fontSize: 12, lineHeight: 16);

  TextStyle bodyXS({required Color color}) => _createBody(color: color, fontSize: 11, lineHeight: 14);

  TextStyle _createBody({required Color color, required double fontSize, required double lineHeight}) =>
      _createStyle(color: color, fontSize: fontSize, lineHeight: lineHeight, fontWeight: FontWeight.w400);
}

mixin _BodyLight {
  TextStyle bodyLightXL({required Color color}) => _createBodyLight(color: color, fontSize: 20, lineHeight: 26);

  TextStyle bodyLightL({required Color color}) => _createBodyLight(color: color, fontSize: 16, lineHeight: 20);

  TextStyle bodyLightM({required Color color}) => _createBodyLight(color: color, fontSize: 14, lineHeight: 18);

  TextStyle bodyLightS({required Color color}) => _createBodyLight(color: color, fontSize: 12, lineHeight: 16);

  TextStyle bodyLightXS({required Color color}) => _createBodyLight(color: color, fontSize: 11, lineHeight: 14);

  TextStyle _createBodyLight({required Color color, required double fontSize, required double lineHeight}) =>
      _createStyle(color: color, fontSize: fontSize, lineHeight: lineHeight, fontWeight: FontWeight.w300);
}

mixin _Button {
  TextStyle button({required Color color}) => _createButton(color: color, fontSize: 16, lineHeight: 20);

  TextStyle _createButton({required Color color, required double fontSize, required double lineHeight}) =>
      _createStyle(color: color, fontSize: fontSize, lineHeight: lineHeight, fontWeight: FontWeight.w600);
}
