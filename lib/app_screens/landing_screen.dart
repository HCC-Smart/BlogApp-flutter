import 'package:blogapp/app_screens/Home_screen.dart';
import 'package:blogapp/app_screens/authentic_screen.dart';
import 'package:blogapp/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User? user = snapshot.data;
            if (user == null) return AuthenticScreen();
            return HomeScreen();
          } else {
            return Scaffold(
              body: Center(child: circularProgress()),
            );
          }
        });
  }
}
