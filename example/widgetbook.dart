import 'package:concordium_wallet/shared_components/button_generated.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:concordium_wallet/shared_components/button.dart';
import 'package:concordium_wallet/shared_components/button_material.dart';

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
      directories: [__button(), __buttonMaterial(), __buttonGenerated()],
    );
  }

  WidgetbookComponent __button() {
    return WidgetbookComponent(
      name: '$Button',
      useCases: [
        WidgetbookUseCase(
          name: 'Default',
          builder: (context) {
            return Button(
              decoration: decoration,
              text: context.knobs.string(
                label: 'Text',
                initialValue: 'Hello World!',
              ),
            );
          },
        )
      ],
    );
  }

  WidgetbookComponent __buttonMaterial() {
    return WidgetbookComponent(
      name: '$ButtonMaterial',
      useCases: [
        WidgetbookUseCase(
          name: 'Default',
          builder: (context) {
            return ButtonMaterial(
              decoration: decoration,
              text: context.knobs.string(
                label: 'Text',
                initialValue: 'Hello World!',
              ),
            );
          },
        )
      ],
    );
  }

  WidgetbookComponent __buttonGenerated() {
    return WidgetbookComponent(
      name: '$ColorGradientMineralIconFalseSizeMedium',
      useCases: [
        WidgetbookUseCase(
          name: 'Default',
          builder: (context) {
            return ColorGradientMineralIconFalseSizeMedium(
            );
          },
        )
      ],
    );
  }

}
