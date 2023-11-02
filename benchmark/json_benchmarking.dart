import 'dart:convert';

import 'package:benchmarking/benchmarking.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:concordium_wallet/services/wallet_proxy/built_value_model.dart';
import 'package:concordium_wallet/services/wallet_proxy/model.dart';
import 'package:concordium_wallet/services/wallet_proxy/serializer.dart';

// https://pub.dev/packages/benchmarking
// dart run ./benchmark/json_benchmarking.dart --release
void main () {
  final testUri = Uri(scheme: 'https', host: 'concordium.com', path: 'hello-world');
  const testVersion = '1.0.0';
  final serializedJson = '{"url": "$testUri", "version": "$testVersion"}';
  final standardSerializers = (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
  String? result; // so that the loop isn't optimized out
  TermsAndConditions? result1;
  TermsAndConditionsV2? result2;
  const count = 10000;
  
  syncBenchmark('json', () {
    for (var i = 0; i < count; i++) {
      result1 = TermsAndConditions.fromJson(jsonDecode(serializedJson));  
    }
  })
  .report(units: count);
  syncBenchmark('built_it', () {
    for (var i = 0; i < count; i++) {
      result2 = standardSerializers.deserializeWith(TermsAndConditionsV2.serializer, jsonDecode(serializedJson));
    }
  })
  .report(units: count);
}
