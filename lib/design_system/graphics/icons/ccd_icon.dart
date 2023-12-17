import 'package:concordium_wallet/design_system/graphics/icons/icon_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/// Use this class whenever you need to use an 'official' design system icon
class CcdIcon extends StatelessWidget {
  const CcdIcon({
    super.key,
    required this.filename,
    required this.size,
    this.color,
  });

  final String filename;
  final IconSize size;
  final Color? color;

  static const _imageFolder = 'assets/design_system/graphics/icons/';

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      '$_imageFolder$filename',
      key: Key(filename),
      height: size.value,
      width: size.value,
      colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
    );
  }

  String get shortName {
    final start = filename.lastIndexOf("/") + 1;
    final end = filename.lastIndexOf(".");
    return filename.substring(start, end);
  }
}
