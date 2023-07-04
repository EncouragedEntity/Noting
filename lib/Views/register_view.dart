// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noting/services/auth/auth_exception.dart';
import 'package:noting/services/auth/bloc/auth_event.dart';
import 'package:noting/widgets/all_widgets.dart';
import '../constants/colors.dart';
import '../services/auth/bloc/auth_bloc.dart';
import '../services/auth/bloc/auth_state.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthRegisteringState) {
          if (state.exception is WeakPasswordException) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Password is too weak"),
              ),
            );
          }

          if (state.exception is EmailIsUsedException) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Email is already in use"),
              ),
            );
          }

          if (state.exception is InvalidMailException) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Invalid email format"),
              ),
            );
          }

          if (state.exception is NotAllowedOperationException) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Sign up operation is not allowed"),
              ),
            );
          }

          if (state.exception is GenericException) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Registration error"),
              ),
            );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Register')),
        body: Container(
          color: AppColors.background,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: ListView(
              children: [
                const SizedBox(height: 24),
                TextFormField(
                  controller: _emailController,
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
                const SizedBox(height: 16),
                TextFormField(
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.visiblePassword,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                FormButton(
                  text: "Register",
                  isSecondary: false,
                  onPressed: () {
                    final email = _emailController.text;
                    final password = _passwordController.text;
                    context
                        .read<AuthBloc>()
                        .add(AuthRegisterEvent(email, password));
                  },
                ),
                const SizedBox(height: 8),
                FormButton(
                  isSecondary: true,
                  text: "Already have an account?",
                  onPressed: () async {
                    context.read<AuthBloc>().add(const AuthLogOutEvent());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
