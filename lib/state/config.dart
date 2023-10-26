import 'package:concordium_wallet/state/network.dart';

class Config {
  /// All available networks in the app.
  final Map<NetworkName, Network> availableNetworks;

  const Config({required this.availableNetworks});

  factory Config.ofNetworks(List<Network> networks) {
    return Config(availableNetworks: {for (final n in networks) n.name: n});
  }
}
