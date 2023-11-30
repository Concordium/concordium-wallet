import 'package:flutter/widgets.dart';

/// Wrapper around a nullable return type in a future.
/// By using this one can use [AsyncSnapshot.hasData] in [FutureBuilder].
class FutureValue<T> {
  T? value;

  FutureValue(this.value);
}
