import 'package:flutter/material.dart';

class Toggle extends StatelessWidget {
  final bool isEnabled;
  final Function(bool)? setEnabled;

  Toggle({super.key, required this.isEnabled, this.setEnabled});

  final MaterialStateProperty<Icon?> icon = MaterialStateProperty.resolveWith<Icon?>(
    (states) => Icon(_iconData(states)),
  );

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
      value: isEnabled,
      onChanged: setEnabled,
    );
  }
}
