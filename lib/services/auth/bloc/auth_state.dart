import 'package:equatable/equatable.dart';
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

class AuthLoggedOutState extends AuthState with EquatableMixin {
  final Exception? exception;
  final bool isLoading;
  const AuthLoggedOutState({
    required this.exception,
    required this.isLoading,
  });
  
  @override
  List<Object?> get props => [exception, isLoading];
}

class AuthUninitializedState extends AuthState {
  const AuthUninitializedState();
}

class AuthRegisteringState extends AuthState {
  final Exception? exception;
  const AuthRegisteringState(this.exception);
}
