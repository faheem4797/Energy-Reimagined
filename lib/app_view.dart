import 'package:energy_reimagined/constants/colors.dart';
import 'package:energy_reimagined/constants/strings.dart';
import 'package:energy_reimagined/features/admin/admin_bottom_navbar.dart';
import 'package:energy_reimagined/features/admin/blocs/admin_nav_bloc/admin_nav_bloc.dart';
import 'package:energy_reimagined/features/admin/jobs/blocs/delete_job_bloc/delete_job_bloc.dart';
import 'package:energy_reimagined/features/admin/jobs/blocs/jobs_stream_bloc/jobs_stream_bloc.dart';
import 'package:energy_reimagined/features/admin/tools/blocs/delete_tool_bloc/delete_tool_bloc.dart';
import 'package:energy_reimagined/features/admin/tools/blocs/tools_stream_bloc/tools_stream_bloc.dart';
import 'package:energy_reimagined/features/admin/users/blocs/users_stream_bloc/users_stream_bloc.dart';
import 'package:energy_reimagined/features/authentication/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:energy_reimagined/features/authentication/screens/welcome_screen.dart';
import 'package:energy_reimagined/features/manager/blocs/escalations_bloc/escalations_bloc.dart';
import 'package:energy_reimagined/features/manager/blocs/manager_nav_bloc/manager_nav_bloc.dart';
import 'package:energy_reimagined/features/manager/blocs/reports_bloc/reports_bloc.dart';
import 'package:energy_reimagined/features/manager/blocs/tools_bloc/tools_bloc.dart';
import 'package:energy_reimagined/features/manager/managerdashboard.dart';
import 'package:energy_reimagined/features/technician/blocs/technician_jobs_stream_bloc/technician_jobs_stream_bloc.dart';
import 'package:energy_reimagined/features/technician/blocs/technician_nav_bloc/technician_nav_bloc.dart';
import 'package:energy_reimagined/features/technician/technician_bottom_navbar.dart';
import 'package:energy_reimagined/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobs_repository/jobs_repository.dart';
import 'package:tools_repository/tools_repository.dart';
import 'package:user_data_repository/user_data_repository.dart';

// import 'package:riddles_with_bloc/blocs/authentication_bloc/authentication_bloc.dart';
// import 'package:riddles_with_bloc/blocs/riddle_time_bloc/riddle_time_bloc.dart';
// import 'package:riddles_with_bloc/blocs/user_bloc/user_bloc.dart';
// import 'package:riddles_with_bloc/screens/admin/home/admin_home_screen.dart';
// import 'package:riddles_with_bloc/screens/authentication/welcome_screen.dart';
// import 'package:riddles_with_bloc/screens/user/home/home_screen.dart';

// import 'package:user_data_repository/user_data_repository.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // useInheritedMediaQuery: true,
      designSize: const Size(393, 830),
      minTextAdapt: true,
      builder: (BuildContext context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        // useInheritedMediaQuery: true,
        // locale: DevicePreview.locale(context),
        // builder: DevicePreview.appBuilder,
        title: ConstStrings.appname,
        theme: ThemeData(
          colorScheme:
              ColorScheme.fromSeed(seedColor: ConstColors.backgroundDarkColor),
          fontFamily: 'Poppins',
          textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Poppins'),
          useMaterial3: true,
        ),
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
          if (state.status == AuthenticationStatus.technicianAuthenticated) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => TechnicianNavBloc(),
                ),
                BlocProvider(
                  create: (context) => TechnicianJobsStreamBloc(
                      jobsRepository: context.read<JobsRepository>(),
                      userId:
                          context.read<AuthenticationBloc>().state.user!.uid),
                ),
              ],
              child: const TechnicianBottomNavBar(),
              //const TechnicianDashboard(),
            );
          } else if (state.status == AuthenticationStatus.adminAuthenticated) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => AdminNavBloc(),
                ),
                BlocProvider(
                  create: (context) => UsersStreamBloc(
                      userDataRepository: context.read<UserDataRepository>()),
                ),
                BlocProvider(
                  create: (context) => ToolsStreamBloc(
                      toolsRepository: context.read<ToolsRepository>()),
                ),
                BlocProvider(
                    create: (context) => DeleteToolBloc(
                        toolsRepository: context.read<ToolsRepository>())),
                BlocProvider(
                  create: (context) => JobsStreamBloc(
                      jobsRepository: context.read<JobsRepository>()),
                ),
                BlocProvider(
                    create: (context) => DeleteJobBloc(
                        jobsRepository: context.read<JobsRepository>()))
              ],
              child: const AdminBottomNavBar(),
            );
          } else if (state.status ==
              AuthenticationStatus.managerAuthenticated) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => ManagerNavBloc(),
                ),
                BlocProvider(
                  create: (context) => EscalationsBloc(
                      jobsRepository: context.read<JobsRepository>()),
                ),
                BlocProvider(
                  create: (context) => ToolsBloc(
                      toolsRepository: context.read<ToolsRepository>()),
                ),
                BlocProvider(
                  create: (context) => ReportsBloc(
                      jobsRepository: context.read<JobsRepository>()),
                ),
              ],
              child: const ManagerDashbaord(),
            );
          } else if (state.status == AuthenticationStatus.unauthenticated) {
            return const WelcomeScreen();
          } else {
            return const SplashScreen();
          }
        }),
      ),
    );
  }
}
