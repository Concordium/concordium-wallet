import 'dart:ui';

import 'package:flutter/material.dart';

abstract class AppPalette {
  //Primary
  static const primaryMineralBlue = Color(0xFF48A2AE);
  static const primaryMineralBlue80 = Color(0xFF6DB5BE);
  static const primaryMineralBlue60 = Color(0xFF91C7CE);
  static const primaryMineralBlue40 = Color(0xFFB6DADF);
  static const primaryMineralBlue20 = Color(0xFFDAECEF);
  static const primaryMineralBlue10 = Color(0xFFECF6F7);
  static const primaryMineralBlue05 = Color(0xFFF6FAFB);

  //Secondary
  static const secondaryDarkBlue = Color(0xFF052535);
  static const secondaryOcean140 = Color(0xFF013243);
  static const secondaryOcean120 = Color(0xFF01475F);
  static const secondaryOceanBlue = Color(0xFF005A78);
  static const secondaryOcean80 = Color(0xFF337B93);
  static const secondaryOcean160 = Color(0xFF7FACBB);
  static const secondaryEggShellWhite = Color(0xFFFFFDE4);
  static const secondaryOffWhite = Color(0xFFEBF0F0);

  //Neutral
  static const neutralBlack = Color(0xFF000000);
  static const neutralGray90 = Color(0xFF191919);
  static const neutralGray80 = Color(0xFF333333);
  static const neutralGray70 = Color(0xFF4c4c4c);
  static const neutralGray60 = Color(0xFF666666);
  static const neutralGray50 = Color(0xFF7f7f7f);
  static const neutralGray40 = Color(0xFF999999);
  static const neutralGray30 = Color(0xFFb2b2b2);
  static const neutralGray20 = Color(0xFFcccccc);
  static const neutralGray10 = Color(0xFFe5e5e5);
  static const neutralGray05 = Color(0xFFf2f2f2);
  static const neutralWhite = Color(0xFFFFFFFF);

  //Dark Mode
  static const darkModeMidnight = Color(0xFF111D2B);
  static const darkModeMidnightDark = Color(0xFF2D415A);
  static const darkModeMidnightLight = Color(0xFF5F7897);

  //State - Negative
  static const negativeDark = Color(0xFFab2b2b);
  static const negativeBase = Color(0xFFDC5050);
  static const negativeLight = Color(0xFFE87E90);

  //State - Positive
  static const positiveDark = Color(0xFF189e46);
  static const positiveBase = Color(0xFF33C364);
  static const positiveLight = Color(0xFF8BE7AA);

  //State - Warning
  static const warningDark = Color(0xFFc89e0a);
  static const warningBase = Color(0xFFFBCD29);
  static const warningLight = Color(0xFFF6DB9A);

  //State - Info
  static const infoDark = Color(0xFF075cab);
  static const infoBase = Color(0xFF2485DF);
  static const infoLight = Color(0xFF65A4DD);

  //State - Help
  static const helpDark = Color(0xFF53198e);
  static const helpBase = Color(0xFF7939BA);
  static const helpLight = Color(0xFFB37CDF);
}
