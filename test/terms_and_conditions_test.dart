import 'package:concordium_wallet/services/url_launcher.dart';
import 'package:concordium_wallet/state.dart';
import 'package:mocktail/mocktail.dart';
import 'package:concordium_wallet/screens/terms_and_conditions/widget.dart';
import 'package:concordium_wallet/screens/terms_and_conditions/screen.dart';
import 'package:concordium_wallet/services/wallet_proxy/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

class MockAppSharedPreferences extends Mock implements AppSharedPreferences {}

class MockAppState extends Mock implements AppState {
  @override
  AppSharedPreferences get sharedPreferences => MockAppSharedPreferences();
}

class MockUrlLauncher extends Mock implements UrlLauncher {}

Widget makeTestableWidget({required Widget? child}) => MaterialApp(
      home: ChangeNotifierProvider<AppState>(
        create: (_) => MockAppState(),
        child: Scaffold(
          body: child,
        ),
      ),
    );

void main() {
  group("Terms and conditions screen", () {
    bool checked = false;
    TermsAndConditionsScreen? tacScreen;

    setUp(() {
      checked = false;
      // Build the terms and condition screen we wish to test
      tacScreen = TermsAndConditionsScreen(
          TermsAndConditionsViewModel(
            TermsAndConditions(Uri.parse("localhost"), "1.1.0"),
            "1.0.0",
            (context) => checked = true,
          ),
          MockUrlLauncher());
    });

    testWidgets('Pressing continue does not perform check', (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(child: tacScreen));

      // TODO add better way to get widget (Not rely on matching strings)
      await tester.tap(find.byKey(const Key("Continue")));

      expect(checked, false);
    });

    testWidgets('Pressing continue, after toggling accept, performs check', (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(child: tacScreen));

      await tester.tap(find.byType(ToggleAcceptedWidget));

      await tester.pump();

      await tester.tap(find.byKey(const Key("Continue")));

      await tester.pump();

      expect(checked, true);
    });
  });

  testWidgets('Clicking on terms and conditions', (WidgetTester tester) async {
    Uri uri = Uri.parse("localhost");
    var launcher = MockUrlLauncher();

    // Build the terms and condition screen we wish to test
    var tacScreen = TermsAndConditionsScreen(
        TermsAndConditionsViewModel(
          TermsAndConditions(uri, "1.1.0"),
          "1.0.0",
          (context) {},
        ),
        launcher);

    await tester.pumpWidget(makeTestableWidget(child: tacScreen));

    when(() => launcher.canLaunch(uri)).thenAnswer((_) => Future.value(true));
    when(() => launcher.launch(uri)).thenAnswer((_) => Future.value(true));

    await tester.tap(find.byKey(const Key("TermsAndConditionsText")));

    verify(() => launcher.launch(uri)).called(1);
  });
}
