import 'package:authentication_repository/authentication_repository.dart';
import 'package:energy_reimagined/app_view.dart';
import 'package:energy_reimagined/blocs/connectivity_bloc/connectivity_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tools_repository/tools_repository.dart';

import 'features/authentication/blocs/authentication_bloc/authentication_bloc.dart';

class MyApp extends StatelessWidget {
  final AuthenticationRepository _authenticationRepository;
  final ToolsRepository _toolsRepository;

  const MyApp(
      {required AuthenticationRepository authenticationRepository,
      required ToolsRepository toolsRepository,
      super.key})
      : _authenticationRepository = authenticationRepository,
        _toolsRepository = toolsRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: _authenticationRepository),
          RepositoryProvider.value(value: _toolsRepository),
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
