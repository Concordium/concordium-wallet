import 'package:concordium_wallet/services/shared_preferences/service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Status of user authentication.
/// This currently only includes whether the user is authenticated or not,
/// but may be expanded with properties like auth method used, auth time/expiry, privileges, etc.
class AuthState {
  /// Whether the user is authenticated.
  final bool _isAuthenticated;

  const AuthState(this._isAuthenticated);

  bool needsAuthentication() {
    return !_isAuthenticated;
  }
}

/// State component for managing authentication.
class Auth extends Cubit<AuthState> {
  /// Service used to persist the accepted T&C version.
  final SharedPreferencesService _prefs;

  Auth(this._prefs) : super(const AuthState(false));

  String _loadActualPassword() {
    final res = _prefs.password;
    if (res == null) {
      throw Exception("no password has been set");
    }
    return res;
  }

  /// Check whether a password has been stored.
  bool canAuthenticate() {
    try {
      _loadActualPassword();
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Attempts to authenticate the user using the provided password.
  /// Returns true if authentication was successful.
  /// Throws an exception if there's no persisted password to authenticate against.
  bool authenticate(String providedPassword) {
    final actualPassword = _loadActualPassword();
    if (actualPassword != providedPassword) {
      return false;
    }
    _setAuthenticated(true);
    return true;
  }

  void _setAuthenticated(bool authenticated) {
    emit(AuthState(authenticated));
  }
  
  Future<bool> setPassword(String password) async {
    await _prefs.writePassword(password);
    // Automatically authenticate the user.
    return authenticate(password);
  }

  Future<void> resetPassword() async {
    await _prefs.deletePassword();
    _setAuthenticated(false);
  }
}
