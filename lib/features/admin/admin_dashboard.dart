import 'package:energy_reimagined/constants/colors.dart';
import 'package:energy_reimagined/widgets/pop_scoop_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminDashbaord extends StatefulWidget {
  const AdminDashbaord({super.key});

  @override
  State<AdminDashbaord> createState() => _AdminDashbaordState();
}

class _AdminDashbaordState extends State<AdminDashbaord> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Admin Screen',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: ConstColors.backgroundDarkColor,
        actions: <Widget>[
          //if (_user != null)
          IconButton(
            icon: const Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            onPressed: () async {
              var logout = await WillPopScoopService()
                  .showLogoutConfirmationDialog(context);
              if (logout) {
                await _auth.signOut();
                setState(() {
                  _user = null;
                });
                FirebaseAuth.instance.authStateChanges().listen((User? user) {
                  if (user == null) {
                    // User is signed out, perform necessary actions (e.g., navigation)
                    // Navigator.pushAndRemoveUntil(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) =>
                    //           const SignIn()), // Redirect to sign-in page
                    //   (route) => false,
                    // );
                  }
                });
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
            'Welcome, Admin this is underdevelopment.',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
