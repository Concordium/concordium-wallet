import 'package:concordium_wallet/state.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:concordium_wallet/screens/terms_and_conditions/widget.dart';
import 'package:concordium_wallet/screens/terms_and_conditions/screen.dart';
import 'package:concordium_wallet/services/wallet_proxy/model.dart';
@GenerateMocks([AppSharedPreferences])
import 'terms_and_conditions_test.mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

class MockAppState extends Mock implements AppState {
  @override
  AppSharedPreferences get sharedPreferences => MockAppSharedPreferences();
}

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
      );
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
}
