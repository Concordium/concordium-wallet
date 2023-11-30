import 'package:concordium_wallet/screens/terms_and_conditions/widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:concordium_wallet/main.dart' as start;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Confirming T&C on the initial page brings us to the reset T&C page and resetting accepted T&C brings us back.', (tester) async {
    // Load app widget.
    start.main();

    await tester.pumpAndSettle();

    expect(find.textContaining('Accepted T&C version', findRichText: true), findsNothing);
    expect(find.textContaining('Before you begin', findRichText: true), findsOneWidget);

    await tester.tap(find.byType(ToggleAcceptedWidget));

    await tester.pump();

    await tester.tap(find.text("Continue", findRichText: true));

    // Trigger a frame.
    await tester.pumpAndSettle();

    expect(find.textContaining('Accepted T&C version', findRichText: true), findsOneWidget);

    await tester.tap(find.text("Reset accepted T&C", findRichText: true));

    // Trigger a frame.
    await tester.pumpAndSettle();

    expect(find.textContaining('Accepted T&C version', findRichText: true), findsNothing);
    expect(find.textContaining('Before you begin', findRichText: true), findsOneWidget);
  });
}
