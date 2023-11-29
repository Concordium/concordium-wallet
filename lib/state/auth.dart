import 'package:flutter_bloc/flutter_bloc.dart';

/// Status of user authentication.
/// This currently only includes whether the user is authenticated or not,
/// but may be expanded with properties like auth method used, auth time/expiry, privileges, etc.
class AuthenticationState {
  /// Whether the user is authenticated.
  final bool _isAuthenticated;

  const AuthenticationState(this._isAuthenticated);

  bool needsAuthentication() {
    return !_isAuthenticated;
  }
}

/// State component for managing authentication.
class Authentication extends Cubit<AuthenticationState> {
  Authentication() : super(const AuthenticationState(false));

  void setAuthenticated(bool authenticated) {
    emit(AuthenticationState(authenticated));
  }
}
