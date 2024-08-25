import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mychat/app/themes.dart';
import 'package:mychat/presentation/screens/home_page.dart';
import 'package:mychat/presentation/screens/login/login_screen.dart';
import 'package:mychat/presentation/screens/verify_email/verify_email_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme(),
      darkTheme: darkTheme(),
      themeMode: ThemeMode.system,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          User? user = snapshot.data;

          if (user == null) {
            return const LoginScreen();
          }

          return user.emailVerified
              ? HomePage(hasBeenUpdated: false)
              : const VerifyEmailScreen();
        },
      ),
    );
  }
}
