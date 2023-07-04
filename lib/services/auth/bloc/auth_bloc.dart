import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noting/services/auth/auth_provider.dart';
import 'package:noting/services/auth/bloc/auth_event.dart';
import 'package:noting/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthLoadingState()) {
    // Initialize
    on<AuthInitializeEvent>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(const AuthLoggedOutState());
      } else if (!user.isEmailVerified) {
        emit(const AuthNeedsVerificationState());
      } else {
        emit(AuthLoggedInState(user));
      }
    });

    //Log in
    on<AuthLogInEvent>((event, emit) async {
      emit(const AuthLoadingState());
      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.logIn(
          email: email,
          password: password,
        );
        emit(AuthLoggedInState(user));
      } on Exception catch (e) {
        emit(AuthLoginFailureState(e));
      }
    });

    //Log out
    on<AuthLogOutEvent>((event, emit) async {
      try {
        emit(const AuthLoadingState());
        await provider.logOut();
        emit(const AuthLoggedOutState());
      } on Exception catch (e) {
        emit(AuthLogoutFailureState(e));
      }
    });
  }
}
