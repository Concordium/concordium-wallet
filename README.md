# Concordium Wallet

Concordium's reference wallet for mobile and web, written in Flutter.

## JSON models

The JSON models used to deserialize the responses from Wallet Proxy are generated using
[`json_serializable`](https://pub.dev/packages/json_serializable).
It works by specifying the data model as plain Dart classes
along with a little special syntax for the `fromJson` and `toJson` methods.
When running the command
```shell
dart run build_runner build
```
the library will expand this syntax into appropriate implementations of these methods
in a new file declared with the `part` directive.

See for example [`wallet_proxy/model.dart`](./lib/services/wallet_proxy/model.dart)
which expands into [`wallet_proxy/model.g.dart`](./lib/services/wallet_proxy/model.g.dart).

The generated class is checked into the repo, but imports always refer to the original one.

## Chrome extension

To build the wallet as a chrome extension, run:
```shell
flutter build web --web-renderer html --csp
```
Then the `build/web/` directory will contain the files for the extension.

To load the extension into Chrome select "Load unpacked" from the "Manage extensions" page (`chrome://extensions/`) and select that directory.
The contents of `build/web/` can be zipped for submitting to the Chrome store.

## Automated Tests

For unit / widget tests, run:
```shell
flutter test
```

For integration tests on android or ios, make sure you have the test device connected and run:
``` shell
flutter test integration_test
```

To run integration tests for web, you must install chromedriver, and run it in a separate terminal:
```shell
chromedriver --port=4444
```
And then run the script:
```shell
./integration_test/run_web_tests.sh
```
If the HEADER environment variable is set, the tests run with a header.

To run a specific test file, examplified here with `test_file_name`, run::
```shell
flutter drive --driver=integration_test/test_driver.dart --target=integration_test/test_file_name.dart -d web-server
```
You can replace `-d web-server` with `-d chrome` for the test to not run headless.

## Licenses

To see the allowed licenses, check out `scripts/license.yaml`.

To get a (readable) list of the licenses of dependencies run:
```
dart run license_checker check-licenses --config scripts/license.yaml
```
