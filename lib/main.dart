import 'package:authentication_repository/authentication_repository.dart';
import 'package:energy_reimagined/app.dart';
import 'package:energy_reimagined/app_bloc_observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobs_repository/jobs_repository.dart';
import 'package:tools_repository/tools_repository.dart';
import 'package:user_data_repository/user_data_repository.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  Bloc.observer = AppBlocObserver();
  final toolsRepository = ToolsRepository();
  final jobsRepository = JobsRepository();
  final userDataRepository = UserDataRepository();

  final authenticationRepository = AuthenticationRepository();
  await authenticationRepository.user.first;

  runApp(MyApp(
    authenticationRepository: authenticationRepository,
    toolsRepository: toolsRepository,
    jobsRepository: jobsRepository,
    userDataRepository: userDataRepository,
  ));
}
