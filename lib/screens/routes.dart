import 'package:concordium_wallet/screens/home/screen.dart';
import 'package:concordium_wallet/states/inherited_hive_box.dart';
import 'package:concordium_wallet/states/inherited_tac.dart';

// TODO: Don't use named routes: https://docs.flutter.dev/cookbook/navigation/named-routes
final appRoutes = {
  '/': (context) {
    var prefs = InheritedHiveBox.of(context).appPrefs;

    return InheritedTac(
        tacState: TacState.instance(prefs), child: const HomeScreen());
  },
};
