import 'package:energy_reimagined/constants/colors.dart';
import 'package:energy_reimagined/features/authentication/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:energy_reimagined/widgets/pop_scoop_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TechnicianDashboard extends StatefulWidget {
  const TechnicianDashboard({super.key});

  @override
  State<TechnicianDashboard> createState() => _TechnicianDashboardState();
}

class _TechnicianDashboardState extends State<TechnicianDashboard> {
  //final FirebaseAuth _auth = FirebaseAuth.instance;

  //User? _user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Technician Screen',
          style: TextStyle(
            color: ConstColors.whiteColor,
          ),
        ),
        backgroundColor: ConstColors.backgroundDarkColor,
        iconTheme: const IconThemeData(
          color: ConstColors.whiteColor,
        ),
        actions: <Widget>[
          //if (_user != null)
          IconButton(
            icon: const Icon(
              Icons.exit_to_app,
              color: ConstColors.whiteColor,
            ),
            onPressed: () async {
              var logout = await WillPopScoopService()
                  .showLogoutConfirmationDialog(context);
              if (logout) {
                if (!mounted) return;
                context
                    .read<AuthenticationBloc>()
                    .add(const AuthenticationLogoutRequested());
                //await _auth.signOut();
                // setState(() {
                //   _user = null;
                // });
                // FirebaseAuth.instance.authStateChanges().listen((User? user) {
                //   if (user == null) {
                // User is signed out, perform necessary actions (e.g., navigation)
                // Navigator.pushAndRemoveUntil(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) =>
                //           const SignIn()), // Redirect to sign-in page
                //   (route) => false,
                // );
                //   }
                // });
              }
              // Navigator.pushAndRemoveUntil(
              //     context,
              //     MaterialPageRoute(builder: (context) => const SignIn()),
              //     (route) => false);
            },
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          return await WillPopScoopService()
              .showCloseConfirmationDialog(context);
        },
        child: const Center(
          child: Text(
            'Welcome, Technician this is underdevelopment.',
            style: TextStyle(
              color: ConstColors.blackColor,
            ),
          ),
        ),
      ),
    );
  }
}
