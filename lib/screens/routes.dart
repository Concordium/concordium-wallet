import 'package:concordium_wallet/screens/configure_authentication/screen.dart';
import 'package:concordium_wallet/screens/home/screen.dart';

// TODO: Don't use named routes: https://docs.flutter.dev/cookbook/navigation/named-routes
final appRoutes = {
  '/': (context) => const HomeScreen(),
  '/auth/configure': (context) => const ConfigureAuthenticationScreen(), // TODO: temporary
};
