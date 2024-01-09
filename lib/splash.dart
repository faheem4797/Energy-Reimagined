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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.asset('assets/images/logo.png')),
    );
  }
}
