import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

abstract class DefaultComponent {
  final String name;

  DefaultComponent({required this.name});

  WidgetbookComponent get component => WidgetbookComponent(name: name, useCases: [_defaultUseCase, ...optionalUseCases]);

  WidgetbookUseCase get _defaultUseCase {
    return WidgetbookUseCase(name: 'Default', builder: (context) => buildDefault(context));
  }

  Widget buildDefault(BuildContext context);

  List<WidgetbookUseCase> get optionalUseCases => [];
}
