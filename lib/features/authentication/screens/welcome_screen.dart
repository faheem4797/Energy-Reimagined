import 'package:authentication_repository/authentication_repository.dart';
import 'package:energy_reimagined/features/authentication/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:energy_reimagined/features/authentication/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => SignInBloc(
          authenticationRepository: context.read<AuthenticationRepository>(),
        ),
        child: const LoginScreen(),
      ),
    );
  }
}
