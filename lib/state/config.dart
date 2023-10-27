import 'package:concordium_wallet/state/network.dart';

/// Global configuration of the app.
/// 
/// For now, the configuration is hardcoded and only contains the network configuration of each available network.
/// 
/// The intent is that it should be loaded from a predefined location that is set with a build parameter
/// and include all necessary information for setting up the services used by the app.
/// This means things like where to find IP info, T&C, forced upgrade config, news, marketplace apps, etc.
///
/// Custom configuration exposed to the user is not intended to live in this object.
class Config {
  /// All available networks and their configuration.
  ///
  /// It will eventually be possible for the user to manage the set of available networks
  /// at which point the source of truth will live somewhere else (with this value being the default).
  ///
  /// At some other point we'll introduce a notion of "enabled" networks,
  /// i.e. the list of networks to be included in the user's network selector.
  /// That list will be a subset of the available networks.
  /// The purpose of describing the concept here already is to allow other doc comments to reference it early.
  final Map<NetworkName, Network> availableNetworks;

  const Config({required this.availableNetworks});

  factory Config.ofNetworks(List<Network> networks) {
    return Config(availableNetworks: {for (final n in networks) n.name: n});
  }
}
