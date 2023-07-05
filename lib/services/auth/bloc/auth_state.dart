import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:noting/services/auth/auth_user.dart';

@immutable
abstract class AuthState {
  final bool isLoading;
  final String? loadingText;
  const AuthState({
    required this.isLoading,
    this.loadingText = 'Wait a sec...',
  });
}

class AuthLoadingState extends AuthState {
  const AuthLoadingState({required super.isLoading});
}

class AuthLoggedInState extends AuthState {
  final AuthUser user;
  const AuthLoggedInState({
    required this.user,
    required super.isLoading,
  });
}

class AuthNeedsVerificationState extends AuthState {
  const AuthNeedsVerificationState({required super.isLoading});
}

class AuthLoggedOutState extends AuthState with EquatableMixin {
  final Exception? exception;
  const AuthLoggedOutState({
    required this.exception,
    required super.isLoading,
    super.loadingText,
  });

  @override
  List<Object?> get props => [exception, isLoading];
}

class AuthUninitializedState extends AuthState {
  const AuthUninitializedState({required super.isLoading});
}

class AuthRegisteringState extends AuthState {
  final Exception? exception;
  const AuthRegisteringState({
    required this.exception,
    required super.isLoading,
  });
}

class AuthForgotPasswordState extends AuthState {
  final Exception? exception;
  final bool hasSentEmail;
  const AuthForgotPasswordState({
    required this.exception,
    required this.hasSentEmail,
    required super.isLoading,
  });
}
