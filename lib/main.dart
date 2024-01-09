import 'package:authentication_repository/authentication_repository.dart';
import 'package:energy_reimagined/app.dart';
import 'package:energy_reimagined/app_bloc_observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobs_repository/jobs_repository.dart';
import 'package:tools_repository/tools_repository.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Bloc.observer = AppBlocObserver();
  final toolsRepository = ToolsRepository();
  final jobsRepository = JobsRepository();
  final authenticationRepository = AuthenticationRepository();
  await authenticationRepository.user.first;

  runApp(MyApp(
    authenticationRepository: authenticationRepository,
    toolsRepository: toolsRepository,
    jobsRepository: jobsRepository,
  ));
}
