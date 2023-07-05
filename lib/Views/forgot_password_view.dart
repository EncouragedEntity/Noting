import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noting/services/auth/auth_exception.dart';
import 'package:noting/services/auth/bloc/auth_bloc.dart';
import 'package:noting/services/auth/bloc/auth_event.dart';
import 'package:noting/utilities/dialogs/password_reset_email_sent_dialog.dart';
import 'package:noting/widgets/all_widgets.dart';

import '../services/auth/bloc/auth_state.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthForgotPasswordState) {
          if (state.hasSentEmail) {
            _controller.clear();
            await showPasswordResetDialog(context);
          }
          if (state.exception is UserNotFoundException) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("User not found"),
              ),
            );
          }
          if (state.exception is InvalidMailException) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Invalid mail"),
              ),
            );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Forgot password'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text('Enter an email to send password reset letter to'),
              TextFormField(
                controller: _controller,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              FormButton(
                text: 'Send password reset letter',
                isSecondary: false,
                onPressed: () {
                  final email = _controller.text;
                  context
                      .read<AuthBloc>()
                      .add(AuthForgotPasswordEvent(email: email));
                },
              ),
              FormButton(
                text: 'Go back',
                isSecondary: false,
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthLogOutEvent());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
