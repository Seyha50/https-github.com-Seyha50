import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bbusrd104/screens/login_screen.dart';
import 'package:bbusrd104/screens/main_screen.dart';

class AppAuth extends StatelessWidget {
  const AppAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, data) {
          if (data.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (data.hasData) {
            return const MainScreen();
          }
          return const LoginScreen();
        }
      );
  }
}
