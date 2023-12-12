import 'package:flutter/material.dart';

abstract class ColorText {
  Color get primary;
  Color get secondary;
  Color get inactive;
}

class ColorTextDark implements ColorText {
  @override
  // TODO: implement inactive
  Color get inactive => throw UnimplementedError();

  @override
  // TODO: implement primary
  Color get primary => throw UnimplementedError();

  @override
  // TODO: implement secondary
  Color get secondary => throw UnimplementedError();
}

class ColorTextLight implements ColorText {
  @override
  // TODO: implement inactive
  Color get inactive => throw UnimplementedError();

  @override
  // TODO: implement primary
  Color get primary => throw UnimplementedError();

  @override
  // TODO: implement secondary
  Color get secondary => throw UnimplementedError();

}