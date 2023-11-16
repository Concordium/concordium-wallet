import 'package:flutter/material.dart';

/// Wrap MaterialApp and Scaffold around the given widget.
Widget wrapMaterial({required Widget? child}) => MaterialApp(home: Scaffold(body: child));
