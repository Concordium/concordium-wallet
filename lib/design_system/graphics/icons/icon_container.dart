import 'package:concordium_wallet/design_system/graphics/icons/ccd_icon.dart';
import 'package:concordium_wallet/design_system/graphics/icons/icon_size.dart';
import 'package:flutter/material.dart';

/// Container for all the official design system icons
///
/// Figma link to icons: https://www.figma.com/file/AXkkkw8sIWE9IUfA5upaeN/New-Concordium-Design-System?type=design&node-id=3852-25424&mode=design&t=YaiOkFszZzHLPJGB-0
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

  CcdIcon close({
    required IconSize size,
    required Color color,
    Key? key,
  }) =>
      CcdIcon(filename: 'close.svg', size: size, color: color, key: key);

  CcdIcon extra({
    required IconSize size,
    required Color color,
    Key? key,
  }) =>
      CcdIcon(filename: 'extra.svg', size: size, color: color, key: key);

  CcdIcon faceId({
    required IconSize size,
    required Color color,
    Key? key,
  }) =>
      CcdIcon(filename: 'face_id.svg', size: size, color: color, key: key);

  CcdIcon help({
    required IconSize size,
    required Color color,
    Key? key,
  }) =>
      CcdIcon(filename: 'help.svg', size: size, color: color, key: key);

  CcdIcon warning({
    required IconSize size,
    required Color color,
    Key? key,
  }) =>
      CcdIcon(filename: 'warning.svg', size: size, color: color, key: key);

  CcdIcon warning2({
    required IconSize size,
    required Color color,
    Key? key,
  }) =>
      CcdIcon(filename: 'warning2.svg', size: size, color: color, key: key);
}
