import 'package:concordium_wallet/screens/home/screen.dart';
import 'package:concordium_wallet/states/inherited_tac.dart';

// TODO: Don't use named routes: https://docs.flutter.dev/cookbook/navigation/named-routes
final appRoutes = {
  '/': (context) => InheritedTac(
    tacState: TacState(),
    child: const HomeScreen()),
};
