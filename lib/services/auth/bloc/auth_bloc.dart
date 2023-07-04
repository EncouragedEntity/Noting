import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noting/services/auth/auth_provider.dart';
import 'package:noting/services/auth/bloc/auth_event.dart';
import 'package:noting/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthUninitializedState()) {
    // Verification
    on<AuthSendEmailVerificationEvent>(((event, emit) async {
      await provider.sendEmailVerification();
      emit(state);
    }));
    // Register
    on<AuthRegisterEvent>((event, emit) async {
      final email = event.email;
      final password = event.password;

      try {
        await provider.createUser(
          email: email,
          password: password,
        );
        await provider.sendEmailVerification();
        emit(const AuthNeedsVerificationState());
      } on Exception catch (e) {
        emit(AuthRegisteringState(e));
      }
    });
    on<AuthShouldRegisterEvent>((event, emit) {
      emit(const AuthRegisteringState(null));
    },);
    // Initialize
    on<AuthInitializeEvent>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(const AuthLoggedOutState(
          exception: null,
          isLoading: false,
        ));
      } else if (!user.isEmailVerified) {
        emit(const AuthNeedsVerificationState());
      } else {
        emit(AuthLoggedInState(user));
      }
    });

    //Log in
    on<AuthLogInEvent>((event, emit) async {
      emit(const AuthLoggedOutState(
        exception: null,
        isLoading: true,
      ));
      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.logIn(
          email: email,
          password: password,
        );

        if (!user.isEmailVerified) {
          emit(const AuthLoggedOutState(
            exception: null,
            isLoading: false,
          ));
          emit(const AuthNeedsVerificationState());
        } else {
          emit(const AuthLoggedOutState(
            exception: null,
            isLoading: false,
          ));
        }

        emit(AuthLoggedInState(user));
      } on Exception catch (e) {
        emit(AuthLoggedOutState(exception: e, isLoading: false));
      }
    });

    //Log out
    on<AuthLogOutEvent>((event, emit) async {
      try {
        await provider.logOut();
        emit(const AuthLoggedOutState(
          exception: null,
          isLoading: false,
        ));
      } on Exception catch (e) {
        emit(AuthLoggedOutState(
          exception: e,
          isLoading: false,
        ));
      }
    });
  }
}
