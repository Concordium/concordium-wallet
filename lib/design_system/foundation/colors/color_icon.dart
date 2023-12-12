import 'package:flutter/material.dart';

abstract class ColorIcon {
  Color get primary;
  Color get secondary;
}

class ColorIconLight implements ColorIcon {
  @override
  // TODO: implement primary
  Color get primary => throw UnimplementedError();

  @override
  // TODO: implement secondary
  Color get secondary => throw UnimplementedError();

}

class ColorIconDark implements ColorIcon {
  @override
  // TODO: implement primary
  Color get primary => throw UnimplementedError();

  @override
  // TODO: implement secondary
  Color get secondary => throw UnimplementedError();

}