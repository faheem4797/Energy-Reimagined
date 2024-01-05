import 'package:energy_reimagined/constants/strings.dart';
import 'package:energy_reimagined/features/authentication/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:energy_reimagined/features/authentication/screens/welcome_screen.dart';
import 'package:energy_reimagined/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          fontFamily: 'Poppins',
          textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Poppins'),
          useMaterial3: true,
        ),
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
          if (state.status == AuthenticationStatus.authenticated) {
            return const Center(child: Text('AUTHENTICATED'));
            // return MultiBlocProvider(providers: [
            //   BlocProvider(
            //     lazy: false,
            //     create: (context) => UserBloc(
            //       userDataRepository: UserDataRepository(
            //           userId:
            //               context.read<AuthenticationBloc>().state.user!.uid),
            //     ),
            //     child: const HomeScreen(),
            //   ),
            // ], child: Container()
            //     //const HomeScreen(),
            //     );
          } else if (state.status == AuthenticationStatus.adminauthenticated) {
            return const Center(child: Text('ADMIN AUTHENTICATED'));
            // const AdminHomeScreen();
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
