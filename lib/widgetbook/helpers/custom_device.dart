import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

abstract class CustomDevice {
  static DeviceInfo get webExtension => DeviceInfo.genericLaptop(
        platform: TargetPlatform.macOS,
        id: 'webExtension',
        name: 'Web Extension',
        screenSize: const Size(1280, 800),
        // TODO(RHA): Check up on the extension dimensions
        windowPosition: const Rect.fromLTRB(0.0, 0.0, 360.0, 780.0),
      );
}
