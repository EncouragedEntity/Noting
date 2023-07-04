import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noting/services/auth/auth_exception.dart';
import 'package:noting/services/auth/auth_service.dart';
import 'package:noting/services/auth/bloc/auth_bloc.dart';
import 'package:noting/services/auth/bloc/auth_event.dart';

import '../widgets/form_button.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Email verification')),
      body: Center(
        child: Column(
          children: [
            const Text("We've sent you verification letter on your email."),
            const Text(
                "\t\tIf you haven't recieved your verification letter, please press the button below"),
            FormButton(
              text: 'Verify',
              isSecondary: false,
              onPressed: () async {
                try {
                  context.read<AuthBloc>().add(const AuthSendEmailVerificationEvent());
                } on UserNotFoundException {
                    context.read<AuthBloc>().add(const AuthLogOutEvent());
                }
              },
            ),
            TextButton(
              child: const Text('Restart'),
              onPressed: () async {
                await AuthService.firebase().logOut();
                context.read<AuthBloc>().add(const AuthShouldRegisterEvent());
              },
            ),
          ],
        ),
      ),
    );
  }
}
