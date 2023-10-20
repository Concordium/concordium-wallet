# Concordium Wallet

Concordium's reference wallet for mobile and web, written in Flutter.

## JSON models

The JSON models used to deserialize the responses from Wallet Proxy are generated using
[`json_serializable`](https://pub.dev/packages/json_serializable).
It works by specifying the data model as plain Dart classes
along with a little special syntax for the `fromJson` and `toJson` methods.
When running the following command
```shell
dart run build_runner build
```
the library will expand this syntax into appropriate implementations of these methods
in a new file declared with the `part` directive.

See for example [`wallet_proxy/model.dart`](./lib/services/wallet_proxy/model.dart)
which expands into [`wallet_proxy/model.g.dart`](./lib/services/wallet_proxy/model.g.dart).

The generated class is checked into the repo, but imports always refer to the original one.
