import 'package:authentication_repository/authentication_repository.dart';
import 'package:energy_reimagined/app_view.dart';
import 'package:energy_reimagined/blocs/connectivity_bloc/connectivity_bloc.dart';
import 'package:energy_reimagined/notification_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobs_repository/jobs_repository.dart';
import 'package:tools_repository/tools_repository.dart';
import 'package:user_data_repository/user_data_repository.dart';

import 'features/authentication/blocs/authentication_bloc/authentication_bloc.dart';

class MyApp extends StatefulWidget {
  final AuthenticationRepository _authenticationRepository;
  final ToolsRepository _toolsRepository;
  final JobsRepository _jobsRepository;
  final UserDataRepository _userDataRepository;

  const MyApp(
      {required AuthenticationRepository authenticationRepository,
      required ToolsRepository toolsRepository,
      required JobsRepository jobsRepository,
      required UserDataRepository userDataRepository,
      super.key})
      : _authenticationRepository = authenticationRepository,
        _toolsRepository = toolsRepository,
        _jobsRepository = jobsRepository,
        _userDataRepository = userDataRepository;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  NotificationServices notificationServices = NotificationServices();
  @override
  void initState() {
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.forgroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.isTokenRefresh();

    notificationServices.getDeviceToken().then((value) {
      if (kDebugMode) {
        print('device token');
        print(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: widget._authenticationRepository),
          RepositoryProvider.value(value: widget._toolsRepository),
          RepositoryProvider.value(value: widget._jobsRepository),
          RepositoryProvider.value(value: widget._userDataRepository),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              lazy: false,
              create: (_) => ConnectivityBloc()..add(CheckConnectionEvent()),
            ),
            BlocProvider(
              create: (_) => AuthenticationBloc(
                  authenticationRepository: widget._authenticationRepository),
            ),
          ],
          child: const AppView(),
        ));
  }
}
