import 'package:flutter/foundation.dart' show immutable;
import 'package:noting/services/auth/auth_user.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

class AuthLoadingState extends AuthState {
  const AuthLoadingState();
}

class AuthLoggedInState extends AuthState {
  final AuthUser user;
  const AuthLoggedInState(this.user);
}

class AuthLoginFailureState extends AuthState {
  final Exception exception;
  const AuthLoginFailureState(this.exception);
}

class AuthNeedsVerificationState extends AuthState {
  const AuthNeedsVerificationState();
}

class AuthLoggedOutState extends AuthState {
  const AuthLoggedOutState();
}

class AuthLogoutFailureState extends AuthState {
  final Exception exception;
  const AuthLogoutFailureState(this.exception);
}