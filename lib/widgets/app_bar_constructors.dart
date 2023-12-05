import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppBarConstructors {
  static AppBar withInfo(BuildContext context, String title, Widget infoWidget) {
    return AppBar(
      backgroundColor: Colors.transparent.withOpacity(0),
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset("assets/graphics/arrow_left.svg")),
      title: Text(
        title,
        style: const TextStyle(color: Color(0xFF48A2AE)),
      ),
      actions: [
        IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => infoWidget));
            },
            icon: SvgPicture.asset("assets/graphics/help.svg"))
      ],
    );
  }
}
