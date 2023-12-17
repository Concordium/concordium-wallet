import 'package:concordium_wallet/design_system/graphics/icons/ccd_icon.dart';
import 'package:concordium_wallet/design_system/graphics/icons/icon_size.dart';
import 'package:flutter/material.dart';

/// Container for all the official design system icons
class IconContainer {
  CcdIcon accordionOpen({
    required IconSize size,
    required Color color,
    Key? key,
  }) =>
      CcdIcon(filename: 'accordion_open.svg', size: size, color: color, key: key);

  CcdIcon add({
    required IconSize size,
    required Color color,
    Key? key,
  }) =>
      CcdIcon(filename: 'add.svg', size: size, color: color, key: key);

  CcdIcon arrowLeft({
    required IconSize size,
    required Color color,
    Key? key,
  }) =>
      CcdIcon(filename: 'arrow_left.svg', size: size, color: color, key: key);

  CcdIcon cancel({
    required IconSize size,
    required Color color,
    Key? key,
  }) =>
      CcdIcon(filename: 'cancel.svg', size: size, color: color, key: key);

  CcdIcon circleAdd({
    required IconSize size,
    Key? key,
  }) =>
      CcdIcon(filename: 'circle_add.svg', size: size, key: key);

  CcdIcon circleSubtract({
    required IconSize size,
    Key? key,
  }) =>
      CcdIcon(filename: 'circle_subtract.svg', size: size, key: key);
}
