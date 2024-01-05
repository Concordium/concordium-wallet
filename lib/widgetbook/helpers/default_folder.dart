import 'package:widgetbook/widgetbook.dart';

/// Convenience class to ensure that widgetbook folders are collapsed by default
class DefaultFolder extends WidgetbookFolder {
  DefaultFolder({required super.name, super.children, super.isInitiallyExpanded = false});
}
