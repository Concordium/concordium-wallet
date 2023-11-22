import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

final buttonStyle = GoogleFonts.getFont(
  "IBM Plex Sans",
  fontWeight: FontWeight.w600,
  fontSize: 16,
  color: const Color(0xFFFFFFFF),
);

const _defaultButtonDecoration = BoxDecoration(
  gradient: LinearGradient(begin: Alignment(1.00, -0.08), end: Alignment(-1, 0.08), colors: [Color(0xFF48A2AE), Color(0xFF005A78)]),
);

final _borderRadius = BorderRadius.circular(16);
const _boxShadow = [
  BoxShadow(
    color: Color(0x26000000),
    blurRadius: 15,
    offset: Offset(0, 0),
    spreadRadius: 0,
  )
];

class Button extends StatelessWidget {
  final String text;
  final GestureTapCallback? onTap;
  final BoxDecoration decoration;
  final double width;
  final double height;

  const Button({
    super.key,
    required this.text,
    this.onTap,
    this.decoration = _defaultButtonDecoration,
    this.width = double.infinity,
    this.height = 40,
  });

  @override
  Widget build(BuildContext context) {
    final buttonDecoration = decoration.copyWith(
      borderRadius: _borderRadius,
      boxShadow: _boxShadow,
    );
    final enabled = onTap != null;

    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
        child: Container(
          height: height,
          width: width,
          decoration: enabled
              ? buttonDecoration
              // TODO allow choosing the disabled styling (Also this doesn't like anything from the design)
              : buttonDecoration.copyWith(color: const Color(0x3348A2AE)),
          child: Center(
            child: Text(text, style: buttonStyle),
          ),
        ),
      ),
    );
  }
}
