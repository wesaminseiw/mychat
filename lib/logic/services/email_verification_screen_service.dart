import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mychat/app/utils/functions.dart';
import 'package:mychat/presentation/screens/home_page.dart';

Future<void> checkEmailVerification(
  BuildContext context, {
  required bool isEmailVerified,
  required User user,
}) async {
  while (!isEmailVerified) {
    await Future.delayed(const Duration(seconds: 3));
    await user.reload();
    user = FirebaseAuth.instance.currentUser!;
    isEmailVerified = user.emailVerified;
    if (isEmailVerified) {
      pushNoReturn(context,
          page: HomePage(
            hasBeenUpdated: false,
          ));
    }
  }
}

Future<void> sendVerificationEmail(
  BuildContext context, {
  required bool canResendEmail,
  required User user,
}) async {
  if (canResendEmail) return;
  canResendEmail = true;

  try {
    await user.sendEmailVerification();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Verification email sent!')),
    );
  } catch (e) {
    print('Error sending verification email: $e');
  }

  // Allow resending after a delay
  await Future.delayed(const Duration(seconds: 60));
  canResendEmail = false;
}
