import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class AuthInitializeEvent extends AuthEvent {
  const AuthInitializeEvent();
}

class AuthLogInEvent extends AuthEvent {
  final String email;
  final String password;

  const AuthLogInEvent(this.email, this.password);
}

class AuthLogOutEvent extends AuthEvent {
  const AuthLogOutEvent();
}
