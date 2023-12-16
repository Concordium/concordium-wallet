import 'package:concordium_wallet/design_system/ccd_theme.dart';
import 'package:concordium_wallet/widgetbook/components/component_folder.dart';
import 'package:concordium_wallet/widgetbook/foundation/foundation_folder.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

void main() {
  runApp(const WidgetbookApp());
}

class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      addons: [
        AlignmentAddon(),
      ],
      directories: [
        FoundationFolder(),
        ComponentFolder(),
      ],
    );
  }
}
