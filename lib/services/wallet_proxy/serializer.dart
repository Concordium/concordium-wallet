library serializers;

import 'package:built_value/serializer.dart';
import 'built_value_model.dart';

part 'serializer.g.dart';

@SerializersFor([
  TermsAndConditionsV2,
])
final Serializers serializers = _$serializers;
