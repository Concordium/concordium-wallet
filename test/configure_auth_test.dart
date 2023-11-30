import 'package:bloc_test/bloc_test.dart';
import 'package:concordium_wallet/screens/configure_authentication/screen.dart';
import 'package:concordium_wallet/state/auth.dart';
import 'package:concordium_wallet/state/terms_and_conditions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

class MockTACCubit extends MockCubit<TermsAndConditionsAcceptanceState> implements TermsAndConditionAcceptance {}

class MockAuthCubit extends MockCubit<AuthenticationState> implements Authentication {}

void main() {
  group('Onboarding: New wallet screen', () {
    late Widget tacScreen;
    late MockTACCubit mockTACCubit;
    late MockAuthCubit mockAuthCubit;

    AuthenticationData? setupWalletData;

    setUp(() {
      setupWalletData = null;

      // Set up mocks for expected cubits.
      mockTACCubit = MockTACCubit();
      mockAuthCubit = MockAuthCubit();

      // Set up screen to be tested.
      tacScreen = BlocProvider<TermsAndConditionAcceptance>.value(
        value: mockTACCubit,
        child: wrapMaterial(
          child: ConfigureAuthenticationForm(
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

      await tester.pumpWidget(wrapMaterial(child: tacScreen));

      // Initial state: Passwords are empty. Button is disabled.
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

      // Set password 1 to one that doesn't match. Button is now disabled again.
      await tester.enterText(passwordInput1Finder, 'yyy');
      await tester.pump();
      expect(tester.widget<ElevatedButton>(continueButtonFinder).enabled, isFalse);

      // As continue was never actually clicked, expect that continue callback wasn't invoked.
      expect(setupWalletData, null);
    });

    testWidgets('Continue handler passes password to callback', (WidgetTester tester) async {
      final continueButtonFinder = find.byKey(const Key('button:continue'));
      final passwordInput1Finder = find.byKey(const Key('input:password1'));
      final passwordInput2Finder = find.byKey(const Key('input:password2'));

      await tester.pumpWidget(wrapMaterial(child: tacScreen));

      // Set valid state for continuing.
      await tester.enterText(passwordInput1Finder, 'p4ssw0rd');
      await tester.enterText(passwordInput2Finder, 'p4ssw0rd');

      await tester.pump();
      await tester.tap(continueButtonFinder);

      // Expect that password and T&C acceptance was passed to handler.
      expect(setupWalletData?.password, 'p4ssw0rd');
      expect(setupWalletData?.enableBiometrics, isFalse);
    });
  });
}
