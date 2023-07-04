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

class AuthNeedsVerificationState extends AuthState {
  const AuthNeedsVerificationState();
}

class AuthLoggedOutState extends AuthState {
  final Exception? exception;
  const AuthLoggedOutState(this.exception);
}

class AuthLogoutFailureState extends AuthState {
  final Exception exception;
  const AuthLogoutFailureState(this.exception);
}