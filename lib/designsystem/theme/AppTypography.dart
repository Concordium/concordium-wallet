import 'package:flutter/cupertino.dart';

abstract class AppTypography {
  //Display
  static const display1 = //bold
      TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.w700,
          height: 47,
          fontFamily: 'IBMPlexSans',);
  static const display2 = TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      height: 36,
      fontFamily: 'IBMPlexSans');
  static const display3 = TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.w700,
      height: 30,
      fontFamily: 'IBMPlexSans');
  static const display4 = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      height: 24,
      fontFamily: 'IBMPlexSans');
  static const display5 = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      height: 19,
      fontFamily: 'IBMPlexSans');
  static const display6 = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      height: 17,
      fontFamily: 'IBMPlexSans');

  //Heading
  static const heading1 = //medium
      TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w500,
          height: 36,
          fontFamily: 'IBMPlexSans');
  static const heading2 = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w500,
      height: 32,
      fontFamily: 'IBMPlexSans');
  static const heading3 = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      height: 28,
      fontFamily: 'IBMPlexSans');
  static const heading4 = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      height: 26,
      fontFamily: 'IBMPlexSans');
  static const heading5 = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 20,
      fontFamily: 'IBMPlexSans');
  static const heading6 = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 18,
      fontFamily: 'IBMPlexSans');
  static const heading7 = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 16,
      fontFamily: 'IBMPlexSans');

  //Body
  static const bodyXL = //regular
      TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w400,
          height: 26,
          fontFamily: 'IBMPlexSans');
  static const bodyL = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 20,
      fontFamily: 'IBMPlexSans');
  static const bodyM = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 18,
      fontFamily: 'IBMPlexSans');
  static const bodyS = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 16,
      fontFamily: 'IBMPlexSans');
  static const bodyXS = TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w400,
      height: 14,
      fontFamily: 'IBMPlexSans');

  //Body Light
  static const bodyLightXL = //light
      TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w300,
          height: 26,
          fontFamily: 'IBMPlexSans');
  static const bodyLightL = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w300,
      height: 20,
      fontFamily: 'IBMPlexSans');
  static const bodyLightM = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w300,
      height: 18,
      fontFamily: 'IBMPlexSans');
  static const bodyLightS = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w300,
      height: 16,
      fontFamily: 'IBMPlexSans');
  static const bodyLightXS = TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w300,
      height: 14,
      fontFamily: 'IBMPlexSans');

  //Button
  static const button = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 20,
      fontFamily: 'IBMPlexSans');
}
