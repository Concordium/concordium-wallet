import 'package:concordium_wallet/design_system/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Wrap MaterialApp and Scaffold around the given widget.
/// The theme is also registered in order to be able to make use of the CcdTheme
Widget wrapMaterial({required Widget? child}) => MultiBlocProvider(
      providers: [
        BlocProvider<AppTheme>(create: (_) => AppTheme()),
      ],
      child: Builder(
        builder: (context) => MaterialApp(
          home: Scaffold(body: child),
          theme: context.watch<AppTheme>().state.themeData,
        ),
      ),
    );
