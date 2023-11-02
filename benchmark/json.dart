import 'dart:convert';

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:concordium_wallet/services/wallet_proxy/built_value_model.dart';
import 'package:concordium_wallet/services/wallet_proxy/model.dart';
import 'package:concordium_wallet/services/wallet_proxy/serializer.dart';

class JsonBenchmark extends BenchmarkBase {
  const JsonBenchmark() : super('Template');

  static void main() {
    const JsonBenchmark().report();
  }

  @override
  void run() {

    final testUri = Uri(scheme: 'https', host: 'concordium.com', path: 'hello-world');
    const testVersion = '1.0.0';
    final serializedJson = '{"url": "$testUri", "version": "$testVersion"}';
    final _ = TermsAndConditions.fromJson(jsonDecode(serializedJson));
  }
}

class BuiltIt extends BenchmarkBase {
  BuiltIt() : super('Template');
  final standardSerializers = (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();

  static void main() {
    BuiltIt().report();
  }

  @override
  void run() {

    final testUri = Uri(scheme: 'https', host: 'concordium.com', path: 'hello-world');
    const testVersion = '1.0.0';
    final serializedJson = '{"url": "$testUri", "version": "$testVersion"}';
    final _ = standardSerializers.deserializeWith(TermsAndConditionsV2.serializer, jsonDecode(serializedJson));
  }
}

// dart run ./benchmark/json.dart --release
void main() {
  // Run TemplateBenchmark
  JsonBenchmark.main();
  BuiltIt.main();
}
