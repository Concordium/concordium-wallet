import 'package:concordium_wallet/design_system/foundation/colors/internal_gradient.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

class ViewGradients {
  WidgetbookComponent get component => WidgetbookComponent(name: 'Gradients', useCases: [
        useCase('Disable', InternalGradient.disable),
      ]);

  WidgetbookUseCase useCase(String name, Gradient gradient) => WidgetbookUseCase(
        name: name,
        builder: (_) => Scaffold(
          body: Container(
              decoration: BoxDecoration(
            gradient: gradient,
          )),
        ),
      ); // buildGradient(InternalGradient.disable));
}
