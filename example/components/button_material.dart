import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// TODO: Move to appropiate file/folder
final buttonStyle = GoogleFonts.getFont(
  "IBM Plex Sans",
  fontWeight: FontWeight.w600,
  fontSize: 16,
  color: Colors.white,
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

class ButtonMaterial extends StatelessWidget {
  final String text;
  final GestureTapCallback? onTap;
  final BoxDecoration decoration;
  final double width;
  final double height;

  const ButtonMaterial({
    super.key,
    required this.text,
    this.onTap,
    required this.decoration,
    this.width = double.infinity,
    this.height = 40,
  });

  @override
  Widget build(BuildContext context) {
    final buttonDecoration = decoration.copyWith(
      borderRadius: _borderRadius,
      boxShadow: _boxShadow,
    );

    return Container(
        height: height,
        width: width,
        decoration: onTap != null
            ? buttonDecoration
            // TODO allow choosing the disabled styling (Also this doesn't like anything from the design)
            : buttonDecoration.copyWith(color: const Color(0x3348A2AE)),
        child: TextButton(onPressed: onTap, child: Text(text, style: buttonStyle)));
  }
}
