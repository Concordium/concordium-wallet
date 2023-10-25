// Name aligned with filename
library built_value_model;

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

// The imported generate code (<name>.g.dart)
part 'built_value_model.g.dart';

abstract class TermsAndConditionsV2 implements Built<TermsAndConditionsV2, TermsAndConditionsV2Builder> {
  Uri get url;
  String get version;

  // Boilerplate code needed to wire-up generated code
  TermsAndConditionsV2._();
  factory TermsAndConditionsV2([Function(TermsAndConditionsV2Builder b) updates]) = _$TermsAndConditionsV2;
  static Serializer<TermsAndConditionsV2> get serializer => _$termsAndConditionsV2Serializer;
}
