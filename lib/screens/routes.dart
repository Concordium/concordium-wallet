import 'package:concordium_wallet/screens/home/home_screen.dart';
import 'package:concordium_wallet/screens/terms_and_conditions/terms_and_conditions_screen.dart';

// TODO: Don't use named routes: https://docs.flutter.dev/cookbook/navigation/named-routes
final appRoutes = {
  '/': (context) => const HomeScreen(),
  '/tac': (context) => const RefreshTermsAndConditionsScreen(),
};
