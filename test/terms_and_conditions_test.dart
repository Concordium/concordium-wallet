import 'package:bloc_test/bloc_test.dart';
import 'package:concordium_wallet/services/url_launcher.dart';
import 'package:concordium_wallet/state/terms_and_conditions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:concordium_wallet/screens/terms_and_conditions/widget.dart';
import 'package:concordium_wallet/screens/terms_and_conditions/screen.dart';
import 'package:concordium_wallet/services/wallet_proxy/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';

import 'helpers.dart';

class MockUrlLauncher extends Mock implements UrlLauncher {}

class MockTACCubit extends MockCubit<TermsAndConditionsAcceptanceState> implements TermsAndConditionAcceptance {}

void main() {
  group("Terms and conditions screen", () {
    bool checked = false;
    late Widget tacScreen;
    late MockTACCubit mockTACCubit;
    late TermsAndConditionsAcceptanceState state;
    const String validVersion = "1.1.0";
    const String acceptedVersion = "1.0.0";

    setUpAll(() {
      registerFallbackValue(AcceptedTermsAndConditions.acceptedNow(validVersion));
    });

    setUp(() {
      checked = false;

      final terms = TermsAndConditions(Uri.parse("localhost"), validVersion);
      state = TermsAndConditionsAcceptanceState(
          accepted: AcceptedTermsAndConditions.acceptedNow(acceptedVersion), valid: ValidTermsAndConditions.refreshedNow(termsAndConditions: terms));

      // Build the terms and condition screen we wish to test
      final rawTacScreen = TermsAndConditionsScreen(validTermsAndConditions: terms, urlLauncher: MockUrlLauncher());
      mockTACCubit = MockTACCubit();

      tacScreen = BlocProvider<TermsAndConditionAcceptance>.value(value: mockTACCubit, child: wrapMaterial(child: rawTacScreen));

      when(() => mockTACCubit.state).thenAnswer((_) => state);
      when(() => mockTACCubit.userAccepted(any())).thenAnswer((_) {
        checked = true;
      });
    });

    testWidgets('Pressing continue does not perform check', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(wrapMaterial(child: tacScreen));

      // Act
      await tester.tap(find.text(AppLocalizationsEn().cont, findRichText: true));

      // Assert
      expect(checked, false);
    });

    testWidgets('Pressing continue, after toggling accept, performs check', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(tacScreen);

      // Act
      await tester.tap(find.byType(ToggleAcceptedWidget));

      await tester.pump();

      await tester.tap(find.text(AppLocalizationsEn().cont, findRichText: true));

      await tester.pump();

      // Assert
      expect(checked, true);
    });
  });

  testWidgets('Clicking on terms and conditions', (WidgetTester tester) async {
    // Arrange
    Uri uri = Uri.parse("localhost");
    var launcher = MockUrlLauncher();

    // Build the terms and condition screen we wish to test
    var tacScreen = TermsAndConditionsScreen(
      validTermsAndConditions: TermsAndConditions(uri, "1.1.0"),
      urlLauncher: launcher,
    );

    await tester.pumpWidget(wrapMaterial(child: tacScreen));

    when(() => launcher.canLaunch(uri)).thenAnswer((_) => Future.value(true));
    when(() => launcher.launch(uri)).thenAnswer((_) => Future.value(true));

    // Act
    await tester.tap(find.textContaining(AppLocalizationsEn().read_and_agree, findRichText: true));

    // Assert
    verify(() => launcher.launch(uri)).called(1);
  });
}
