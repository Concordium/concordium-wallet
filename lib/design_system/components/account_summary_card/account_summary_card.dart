import 'package:concordium_wallet/design_system/components/account_summary_card/card_decorations.dart';
import 'package:concordium_wallet/design_system/theme.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AccountSummaryCard extends StatelessWidget {
  // TODO(RHA): Move this to a const file
  static const ccdSymbol = '\u03FE';

  final String accountLabel;
  final String atDisposalLabel;
  final String balanceLabel;

  final int accounts;
  final double atDisposal;
  final double ccdAmount;
  final double fiatAmount;
  final CardDecorations decoration;
  static const double height = 170;
  static const double width = 343;

  const AccountSummaryCard(
      {required this.accounts,
      required this.atDisposal,
      required this.ccdAmount,
      required this.fiatAmount,
      required this.decoration,
      super.key,
      required this.accountLabel,
      required this.atDisposalLabel,
      required this.balanceLabel});

  @override
  Widget build(BuildContext context) {
    Widget cardInterior = DefaultTextStyle.merge(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("$accounts $accountLabel", style: bodyS),
              const Spacer(),
              Text(atDisposalLabel, style: bodyS),
              Text("Ͼ $atDisposal", style: heading5),
            ]),
            const Spacer(),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(balanceLabel, style: bodyS),
              Text("$ccdSymbol $ccdAmount", style: heading2),
              Text("\$ $fiatAmount", style: bodyL),
              const Spacer(),
              SvgPicture.asset('assets/graphics/CCD.svg')
            ]),
          ]),
        ),
        style: const TextStyle(color: Color(0xFFFFFFFF)));

    final decoratedCard = decoration.gradients.fold(cardInterior, (previousValue, element) => _addGradient(element, previousValue));

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
      ),
      height: height,
      width: width,
      child: decoratedCard,
    );
  }

  Widget _addGradient(Gradient gradient, Widget widget) {
    return Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(18),
        ),
        child: widget);
  }
}
