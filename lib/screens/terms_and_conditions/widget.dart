import 'package:flutter/material.dart';

class ToggleAcceptedWidget extends StatelessWidget {
  final bool isAccepted;
  final Function(bool) setAccepted;

  ToggleAcceptedWidget({super.key, required this.isAccepted, required this.setAccepted});

  final MaterialStateProperty<Icon?> icon = MaterialStateProperty.resolveWith<Icon?>((states) => Icon(_iconData(states)));

  static IconData _iconData(Set<MaterialState> states) {
    if (states.contains(MaterialState.selected)) {
      return Icons.check;
    }
    return Icons.close;
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      thumbIcon: icon,
      value: isAccepted,
      onChanged: setAccepted,
    );
  }
}
