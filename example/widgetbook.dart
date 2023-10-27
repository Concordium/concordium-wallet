import 'package:concordium_wallet/shared_components/account_summary_card/account_summary_card.dart';
import 'package:concordium_wallet/shared_components/account_summary_card/card_decorations.dart';
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
      directories: [_button(), _buttonMaterial(), _buttonGenerated(), _accountSummaryCard()],
    );
  }

  WidgetbookComponent _button() {
    return WidgetbookComponent(
      name: '$Button',
      useCases: [
        WidgetbookUseCase(
          name: 'Default',
          builder: (context) {
            return Button(
              decoration: decoration,
              onTap: context.knobs.listOrNull(label: "onTap", options: [() {}]),
              width: context.knobs.double.input(
                label: 'Width',
                initialValue: double.infinity,
              ),
              height: context.knobs.double.input(
                label: 'Height',
                initialValue: 40,
              ),
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

  WidgetbookComponent _buttonMaterial() {
    return WidgetbookComponent(
      name: '$ButtonMaterial',
      useCases: [
        WidgetbookUseCase(
          name: 'Default',
          builder: (context) {
            return ButtonMaterial(
              decoration: decoration,
              onTap: context.knobs.listOrNull(label: "onTap", options: [() {}]),
              width: context.knobs.double.input(
                label: 'Width',
                initialValue: double.infinity,
              ),
              height: context.knobs.double.input(
                label: 'Height',
                initialValue: 40,
              ),
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

  WidgetbookComponent _buttonGenerated() {
    return WidgetbookComponent(
      name: '$ColorGradientMineralIconFalseSizeMedium',
      useCases: [
        WidgetbookUseCase(
          name: 'Default',
          builder: (context) {
            return ColorGradientMineralIconFalseSizeMedium();
          },
        )
      ],
    );
  }

  WidgetbookComponent _accountSummaryCard() {
    return WidgetbookComponent(
      name: '$AccountSummaryCard',
      useCases: [
        WidgetbookUseCase(
          name: 'Default',
          builder: (context) {
            return AccountSummaryCard(
              accounts: 1,
              atDisposal: context.knobs.double.input(label: 'At disposal', initialValue: 100),
              totalAmount: context.knobs.double.input(label: 'total amount', initialValue: 200),
              dollarAmount: context.knobs.double.input(label: 'dollar amount', initialValue: 100),
              decoration: context.knobs.list(label: 'gradients', options: [CardDecorations.teal, CardDecorations.orange, CardDecorations.purple])
            );
          },
        )
      ],
    );
  }
}

