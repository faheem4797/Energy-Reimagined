import 'package:authentication_repository/authentication_repository.dart';
import 'package:energy_reimagined/app_view.dart';
import 'package:energy_reimagined/blocs/connectivity_bloc/connectivity_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/authentication/blocs/authentication_bloc/authentication_bloc.dart';

class MyApp extends StatelessWidget {
  final AuthenticationRepository _authenticationRepository;

  const MyApp(
      {required AuthenticationRepository authenticationRepository, super.key})
      : _authenticationRepository = authenticationRepository;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: _authenticationRepository),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => ConnectivityBloc(),
            ),
            BlocProvider(
              create: (_) => AuthenticationBloc(
                  authenticationRepository: _authenticationRepository),
            ),
          ],
          child: const AppView(),
        ));
  }
}
