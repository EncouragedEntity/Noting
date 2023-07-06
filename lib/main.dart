// ignore_for_file: prefer_const_constructors, avoid_printRegisterView
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noting/Views/forgot_password_view.dart';
import 'package:noting/constants/colors.dart';
import 'package:noting/helpers/loading/loading_screen.dart';
import 'package:noting/services/auth/bloc/auth_bloc.dart';
import 'package:noting/services/auth/bloc/auth_event.dart';
import 'package:noting/services/auth/bloc/auth_state.dart';
import 'package:noting/services/auth/firebase_auth_provider.dart';
import 'Views/all_views.dart';
import 'constants/routes.dart';
// ignore: unused_import
import 'dart:developer' as devtools show log;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Color primaryColor = AppColors.primary;
  MaterialColor customPrimarySwatch = MaterialColor(
    primaryColor.value,
    <int, Color>{
      50: primaryColor.withOpacity(0.1),
      100: primaryColor.withOpacity(0.2),
      200: primaryColor.withOpacity(0.3),
      300: primaryColor.withOpacity(0.4),
      400: primaryColor.withOpacity(0.5),
      500: primaryColor.withOpacity(0.6),
      600: primaryColor.withOpacity(0.7),
      700: primaryColor.withOpacity(0.8),
      800: primaryColor.withOpacity(0.9),
      900: primaryColor.withOpacity(1.0),
    },
  );

  runApp(
    MaterialApp(
      title: 'Noting',
      theme: ThemeData(
        primarySwatch: customPrimarySwatch,
      ),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: HomePage(),
      ),
      routes: {
        AppRoutes.createUpdate: (context) => const CreateUpdateNoteView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthInitializeEvent());

    return BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
      if (state.isLoading) {
        LoadingScreen()
            .show(context: context, text: state.loadingText ?? 'Wait a sec...');
      } else {
        LoadingScreen().hide();
      }
    }, builder: (context, state) {
      if (state is AuthRegisteringState) {
        return const RegisterView();
      }

      if (state is AuthLoggedInState) {
        return const NotesView();
      }
      if (state is AuthNeedsVerificationState) {
        return const VerifyEmailView();
      }
      if (state is AuthLoggedOutState) {
        return const LoginView();
      }
      if (state is AuthForgotPasswordState) {
        return const ForgotPasswordView();
      }
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    });
  }
}
