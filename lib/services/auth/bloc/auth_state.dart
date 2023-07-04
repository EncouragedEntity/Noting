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
  const AuthLoadingState({required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthLoggedInState extends AuthState {
  final AuthUser user;
  const AuthLoggedInState({
    required this.user,
    required bool isLoading,
  }) : super(isLoading: isLoading);
}

class AuthNeedsVerificationState extends AuthState {
  const AuthNeedsVerificationState({required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthLoggedOutState extends AuthState with EquatableMixin {
  final Exception? exception;
  const AuthLoggedOutState({
    required this.exception,
    required isLoading,
    String? loadingText,
  }) : super(
          isLoading: isLoading,
          loadingText: loadingText,
        );

  @override
  List<Object?> get props => [exception, isLoading];
}

class AuthUninitializedState extends AuthState {
  const AuthUninitializedState({required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthRegisteringState extends AuthState {
  final Exception? exception;
  const AuthRegisteringState({
    required this.exception,
    required isLoading,
  }) : super(isLoading: isLoading);
}
