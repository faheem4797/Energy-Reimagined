// ignore_for_file: use_build_context_synchronously

// import 'package:energy_reimagined/features/manager/managerdashboard.dart';
// import 'package:energy_reimagined/features/technician/techniciandashboard.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // void showLoadingIndicator() {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return const Align(
  //         alignment: Alignment.bottomCenter,
  //         child: Padding(
  //           padding: EdgeInsets.only(top: 350),
  //           child: Dialog(
  //             child: Padding(
  //               padding: EdgeInsets.all(20.0),
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   CircularProgressIndicator(),
  //                   SizedBox(height: 20),
  //                   Text(
  //                     'Authenticating your account.',
  //                     textAlign: TextAlign.center,
  //                     style: TextStyle(
  //                       fontSize: 16,
  //                       fontFamily: 'Poppins',
  //                       fontWeight: FontWeight.w400,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  // void hideLoadingIndicator() {
  //   Navigator.of(context, rootNavigator: true).pop();
  // }

  // void splashAuthenticate() async {
  //   // Display loading indicator while checking authentication
  //   //showLoadingIndicator();
  //   await Future.delayed(const Duration(seconds: 5));

  //   try {
  //     // Check authentication
  //     Map<String, dynamic> authInfo = await checkAuthentication();

  //     if (authInfo['isAuthenticated']) {
  //       // User is authenticated, redirect based on role
  //       String role = authInfo['role'];
  //       if (role == 'admin') {
  //         // Redirect to admin page
  //         // Navigator.pushAndRemoveUntil(
  //         //   context,
  //         //   MaterialPageRoute(builder: (context) => const AdminDashboard()),
  //         //   (route) => false,
  //         // );
  //       } else if (role == 'manager') {
  //         // Redirect to manager page
  //         Navigator.pushAndRemoveUntil(
  //           context,
  //           MaterialPageRoute(builder: (context) => const ManagerDashbaord()),
  //           (route) => false,
  //         );
  //       } else if (role == 'technician') {
  //         // Redirect to technician page
  //         Navigator.pushAndRemoveUntil(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) => const TechnicianDashboard()),
  //           (route) => false,
  //         );
  //       }
  //     } else {
  //       //hideLoadingIndicator();
  //       // Not authenticated, navigate to sign-in page
  //       // Navigator.pushAndRemoveUntil(
  //       //   context,
  //       //   MaterialPageRoute(builder: (context) => const SignIn()),
  //       //   (route) => false,
  //       // );
  //     }
  //   } catch (e) {
  //     // Hide loading indicator in case of error
  //     //hideLoadingIndicator();
  //     // Handle authentication error
  //     // Navigator.pushAndRemoveUntil(
  //     //   context,
  //     //   MaterialPageRoute(builder: (context) => const SignIn()),
  //     //   (route) => false,
  //     // );
  //   }
  // }

  // Future<Map<String, dynamic>> checkAuthentication() async {
  //   User? user = FirebaseAuth.instance.currentUser;
  //   Map<String, dynamic> authInfo = {'isAuthenticated': false, 'role': ''};

  //   if (user != null) {
  //     String userId = user.uid;

  //     DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
  //         .instance
  //         .collection('users')
  //         .doc(userId)
  //         .get();

  //     if (userDoc.exists) {
  //       String role = userDoc.get('role') ??
  //           ''; // Default empty string if 'role' doesn't exist

  //       // Check the user's role and set the authentication info
  //       if (role == 'admin' || role == 'manager' || role == 'technician') {
  //         authInfo['isAuthenticated'] = true;
  //         authInfo['role'] = role;
  //       }
  //     }
  //   }

  //   if (!authInfo['isAuthenticated']) {
  //     throw FirebaseAuthException(
  //         message: 'User authentication failed.', code: '404');
  //   }

  //   return authInfo;
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     // This method will be called after the first frame is displayed
  //     splashAuthenticate();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.asset('assets/images/logo.png')
          // child: Text(
          //   ConstStrings.appname,
          //   style: TextStyle(
          //     fontFamily: 'Poppins',
          //     fontWeight: FontWeight.w400,
          //     fontSize: 20,
          //     color: Colors.black,
          //   ),
          // ),
          ),
    );
  }
}
