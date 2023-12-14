import 'package:concordium_wallet/design_system/components/account_summary_card/account_summary_card.dart';
import 'package:concordium_wallet/design_system/components/account_summary_card/card_decorations.dart';
import 'package:concordium_wallet/widgetbook/example/components/button_generated.dart';
import 'package:concordium_wallet/widgetbook/example/components/button_material.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:concordium_wallet/design_system/components/buttons/button.dart';

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
      directories: [__buttons(), _accountSummaryCard()],
    );
  }

  WidgetbookComponent __buttons() {
    return WidgetbookComponent(
      name: 'Buttons',
      useCases: [
        WidgetbookUseCase(
          name: 'Default',
          builder: (context) {
            return Button(
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
        ),
        WidgetbookUseCase(
          name: 'Material',
          builder: (context) {
            return ButtonMaterial(
              decoration: defaultButtonDecoration,
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
        ),
        WidgetbookUseCase(
          name: 'Generated',
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
              ccdAmount: context.knobs.double.input(label: 'total amount', initialValue: 200),
              fiatAmount: context.knobs.double.input(label: 'dollar amount', initialValue: 100),
              decoration: context.knobs.list(label: 'gradients', options: [CardDecorations.teal, CardDecorations.orange, CardDecorations.purple]),
              accountLabel: 'accounts',
              atDisposalLabel: 'At disposal',
              balanceLabel: 'Total Wallet Balance',
            );
          },
        )
      ],
    );
  }
}
