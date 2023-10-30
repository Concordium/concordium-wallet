// Import the test package and Counter class
import 'package:built_value/standard_json_plugin.dart';
import 'package:test/test.dart';
import 'package:concordium_wallet/services/wallet_proxy/model.dart';
import 'package:concordium_wallet/services/wallet_proxy/built_value_model.dart';
import 'dart:convert';
import 'package:concordium_wallet/services/wallet_proxy/serializer.dart';

final testUri = Uri(scheme: 'https', host: 'concordium.com', path: 'hello-world');
const testVersion = '1.0.0';
final serializedJson = '{"url": "$testUri", "version": "$testVersion"}';

void main() {
  test('json_serializable test', () {
    TermsAndConditions expected = TermsAndConditions(testUri, testVersion);

    final result = TermsAndConditions.fromJson(jsonDecode(serializedJson));

    expect(result.url, expected.url);
    expect(result.version, expected.version);
  });

  test('built_value test', () {
    final expected = TermsAndConditionsV2((b) => b
      ..url = testUri
      ..version = testVersion);

    final standardSerializers = (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
    TermsAndConditionsV2? result = standardSerializers.deserializeWith(TermsAndConditionsV2.serializer, jsonDecode(serializedJson));

    expect(result?.url, expected.url);
    expect(result?.version, expected.version);
  });
}
