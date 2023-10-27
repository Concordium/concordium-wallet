import 'package:concordium_wallet/shared_components/account_summary_card/card_decorations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

// TODO move fonts to a more general place

final bodyL = GoogleFonts.getFont(
  "IBM Plex Sans",
  fontWeight: FontWeight.w400,
  fontSize: 16,
);

final bodyS = GoogleFonts.getFont(
  "IBM Plex Sans",
  fontWeight: FontWeight.w400,
  fontSize: 12,
);

final heading2 = GoogleFonts.getFont(
  "IBM Plex Sans",
  fontWeight: FontWeight.w500,
  fontSize: 24,
);

final heading5 = GoogleFonts.getFont(
  "IBM Plex Sans",
  fontWeight: FontWeight.w500,
  fontSize: 16,
);

class AccountSummaryCard extends StatelessWidget {
  final int accounts;
  final double atDisposal;
  final double totalAmount;
  final double dollarAmount;
  final CardDecorations decoration;
  static const double height = 170;
  static const double width = 343;

  const AccountSummaryCard({required this.accounts, required this.atDisposal, required this.totalAmount,
      required this.dollarAmount, required this.decoration,
      super.key});

  @override
  Widget build(BuildContext context) {
    Widget cardInterior =
    DefaultTextStyle.merge(
      child :Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "$accounts accounts",
                                style: bodyS),
                            const Spacer(),
                            Text(
                              "At disposal",
                                style: bodyS),
                            Text("Ͼ $atDisposal", style: heading5),
                          ]),
                      const Spacer(),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                                "Total Wallet Balance",
                                style: bodyS),
                            Text("\u03FE $totalAmount", style: heading2),
                            Text("\$ $dollarAmount", style: bodyL),
                            const Spacer(),
                            SvgPicture.asset('assets/graphics/CCD.svg')
                          ]),
                    ]),
                  ),
                  style: const TextStyle(color:Color(0xFFFFFFFF) )
                );

    final decoratedCard = decoration.gradients.fold(cardInterior,
        (previousValue, element) => _addGradient(element, previousValue));

    return
        Container(
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
