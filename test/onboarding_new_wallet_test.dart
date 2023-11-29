import 'package:bloc_test/bloc_test.dart';
import 'package:concordium_wallet/screens/onboarding/new/screen.dart';
import 'package:concordium_wallet/services/url_launcher.dart';
import 'package:concordium_wallet/services/wallet_proxy/model.dart';
import 'package:concordium_wallet/state/auth.dart';
import 'package:concordium_wallet/state/terms_and_conditions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'helpers.dart';

class MockUrlLauncher extends Mock implements UrlLauncher {}

class MockTACCubit extends MockCubit<TermsAndConditionsAcceptanceState> implements TermsAndConditionAcceptance {}

class MockAuthCubit extends MockCubit<AuthenticationState> implements Authentication {}

void main() {
  group('Onboarding: New wallet screen', () {
    late Widget tacScreen;
    late MockTACCubit mockTACCubit;
    late MockAuthCubit mockAuthCubit;

    const String validVersion = "1.1.0";

    SetupWalletData? setupWalletData;

    setUp(() {
      setupWalletData = null;

      final validTac = ValidTermsAndConditions(
        refreshedAt: DateTime(0),
        termsAndConditions: TermsAndConditions(Uri.parse("localhost"), validVersion),
      );

      // Set up mocks for expected cubits.
      mockTACCubit = MockTACCubit();
      mockAuthCubit = MockAuthCubit();

      // Set up screen to be tested.
      tacScreen = BlocProvider<TermsAndConditionAcceptance>.value(
        value: mockTACCubit,
        child: wrapMaterial(
          child: OnboardingNewWalletForm(
            validTermsAndConditions: validTac,
            onContinuePressed: (data) {
              setupWalletData = data;
            },
          ),
        ),
      );
    });

    testWidgets('Continue button is disabled unless passwords match and T&C is accepted', (WidgetTester tester) async {
      final continueButtonFinder = find.byKey(const Key('button:continue'));
      final passwordInput1Finder = find.byKey(const Key('input:password1'));
      final passwordInput2Finder = find.byKey(const Key('input:password2'));
      final acceptTacFinder = find.byKey(const Key('input:accept-tac'));

      await tester.pumpWidget(wrapMaterial(child: tacScreen));

      // Initial state: Passwords are empty and T&C is not accepted. Button is disabled.
      expect(tester.widget<ElevatedButton>(continueButtonFinder).enabled, isFalse);

      // Accept T&C. Button is still disabled.
      await tester.tap(acceptTacFinder);
      await tester.pump();
      expect(tester.widget<ElevatedButton>(continueButtonFinder).enabled, isFalse);

      // Set password 1. Button is still disabled.
      await tester.enterText(passwordInput1Finder, 'p4ssw0rd');
      await tester.pump();
      expect(tester.widget<ElevatedButton>(continueButtonFinder).enabled, isFalse);

      // Set password 2 to one that isn't matching. Button is still disabled.
      await tester.enterText(passwordInput2Finder, 'xxx');
      await tester.pump();
      expect(tester.widget<ElevatedButton>(continueButtonFinder).enabled, isFalse);

      // Set password 2 to one that matches. Button is now enabled.
      await tester.enterText(passwordInput2Finder, 'p4ssw0rd');
      await tester.pump();
      expect(tester.widget<ElevatedButton>(continueButtonFinder).enabled, isTrue);

      // Un-accept T&C. Button is disabled again.
      await tester.tap(acceptTacFinder);
      await tester.pump();
      expect(tester.widget<ElevatedButton>(continueButtonFinder).enabled, isFalse);

      // As continue was never actually clicked, expect that continue callback wasn't invoked.
      expect(setupWalletData, null);
    });

    testWidgets('Continue button sets password and T&C acceptance, then navigates to home', (WidgetTester tester) async {
      final continueButtonFinder = find.byKey(const Key('button:continue'));
      final passwordInput1Finder = find.byKey(const Key('input:password1'));
      final passwordInput2Finder = find.byKey(const Key('input:password2'));
      final acceptTacFinder = find.byKey(const Key('input:accept-tac'));

      await tester.pumpWidget(wrapMaterial(child: tacScreen));

      // Set valid state for continuing.
      await tester.enterText(passwordInput1Finder, 'p4ssw0rd');
      await tester.enterText(passwordInput2Finder, 'p4ssw0rd');
      await tester.tap(acceptTacFinder);

      await tester.pump();
      await tester.tap(continueButtonFinder);

      // Expect that password and T&C acceptance was passed to handler.
      expect(setupWalletData?.password, 'p4ssw0rd');
      expect(setupWalletData?.enableBiometrics, isFalse);
      expect(setupWalletData?.acceptedTermsAndConditions.version, validVersion);
    });

    // testWidgets('Pressing continue does not perform check', (WidgetTester tester) async {
    //   // Arrange
    //   await tester.pumpWidget(wrapMaterial(child: tacScreen));
    //
    //   // Act
    //   // TODO use internationalized version here.
    //   await tester.tap(find.text("Continue", findRichText: true));
    //
    //   // Assert
    //   expect(userAcceptedVersion, null);
    // });
    //
    // testWidgets('Pressing continue, after toggling accept, registers acceptance', (WidgetTester tester) async {
    //   // Arrange
    //   await tester.pumpWidget(tacScreen);
    //
    //   // Act
    //   final tacAcceptToggle = find.byType(Toggle).last;
    //   await tester.tap(tacAcceptToggle);
    //
    //   await tester.pump();
    //
    //   // TODO use internationalized version here.
    //   await tester.tap(find.text("Continue", findRichText: true));
    //
    //   await tester.pump();
    //
    //   // Assert
    //   expect(userAcceptedVersion, null);
    // });
    //
    // testWidgets('Clicking on terms and conditions', (WidgetTester tester) async {
    //   // Arrange
    //   Uri uri = Uri.parse("localhost");
    //   var launcher = MockUrlLauncher();
    //
    //   // Build the terms and condition screen we wish to test
    //   var tacScreen = TermsAndConditionsScreen(
    //     validTermsAndConditions: TermsAndConditions(uri, "1.1.0"),
    //     urlLauncher: launcher,
    //   );
    //
    //   await tester.pumpWidget(wrapMaterial(child: tacScreen));
    //
    //   when(() => launcher.canLaunch(uri)).thenAnswer((_) => Future.value(true));
    //   when(() => launcher.launch(uri)).thenAnswer((_) => Future.value(true));
    //
    //   // Act
    //   // TODO use internationalized version here.
    //   await tester.tap(find.textContaining("I have read and agree to the", findRichText: true));
    //
    //   // Assert
    //   verify(() => launcher.launch(uri)).called(1);
    // });
  });
}
