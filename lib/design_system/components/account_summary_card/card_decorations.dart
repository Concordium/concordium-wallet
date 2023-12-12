import 'package:flutter/widgets.dart';

enum CardDecorations {
  teal(gradients: [_tealGradient1, _tealGradient2]),
  purple(gradients: [_purpleGradient1]),
  orange(gradients: [_orangeGradient1, _orangeGradient2, _orangeGradient3]);

  final List<Gradient> gradients;

  const CardDecorations({required this.gradients});
}

const Gradient _tealGradient2 = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  stops: [0.0, 1.0],
  colors: [
    Color(0xFF005A78),
    Color(0xFF2E8894),
  ],
  transform: GradientRotation(157.3 * 3.14159 / 180),
);

const Gradient _tealGradient1 = RadialGradient(
  center: Alignment(0.6545, 1.2353),
  radius: 0.6941,
  colors: [
    Color.fromRGBO(51, 195, 100, 0.3),
    Color.fromRGBO(51, 195, 100, 0),
  ],
  stops: [0, 1],
);

const _orangeGradient3 = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFFEA7F02),
    Color(0xFFFC9410),
    Color(0xFFF4AB01),
  ],
);

const _orangeGradient2 = RadialGradient(
  center: Alignment(0.57, 0.53),
  radius: 0.52,
  colors: [Color.fromRGBO(255, 122, 0, 100), Color.fromRGBO(255, 122, 0, 0)],
);

const _orangeGradient1 = RadialGradient(
  center: Alignment(0.5, 0.5),
  radius: 0.52,
  colors: [Color.fromRGBO(255, 255, 255, 60), Color.fromRGBO(255, 255, 255, 0)],
);

const _purpleGradient1 = LinearGradient(
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
  colors: [
    Color(0xFF007FF4),
    Color(0xFF287CFC),
    Color(0xFFF23FC9),
    Color(0xFFFF007A),
  ],
  stops: [
    0,
    0.4,
    0.5,
    0.8,
  ],
);
