
import 'package:finance/features/authentication/view/login_page.dart';
import 'package:finance/features/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseStream extends StatelessWidget {
  const FirebaseStream({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text('Что то пошло не так!'),
            ),
          );
        } else if (snapshot.hasData) {
          if (FirebaseAuth.instance.currentUser != null) {
            return HomePage();
          } else {
            return LoginPage();
          }

        }
        return LoginPage();
      },
    );
  }
}
