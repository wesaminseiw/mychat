import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mychat/app/utils/functions.dart';
import 'package:mychat/presentation/screens/customize_profile/customize_profile_screen.dart';
import 'package:mychat/presentation/screens/home_page.dart';
import 'package:mychat/presentation/screens/login/login_screen.dart';
import 'package:mychat/presentation/widgets/dialogs/show_error_dialog.dart';

bool resetPassword = true;

void loginProcess(
  BuildContext context, {
  required String email,
  required String password,
}) async {
  bool resetPassword = false;
  try {
    UserCredential credentials = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    pushNoReturn(context,
        page: HomePage(
          hasBeenUpdated: false,
        ));
  } on FirebaseAuthException catch (e) {
    late bool _resetPassword;
    if (e.code == 'user-not-found') {
      resetPassword = false;
      showErrorDialog(
        context: context,
        title: 'Invalid credentials',
      );
      resetPassword = false;
    } else if (e.code == 'wrong-password') {
      resetPassword = true;
      showErrorDialog(
        context: context,
        title: 'Invalid credentials',
      );
      resetPassword = true;
      print('====== $resetPassword ========');
    } else if (e.code == 'channel-error') {
      resetPassword = false;
      showErrorDialog(
        context: context,
        title: 'Email or password cannot be empty',
      );
      resetPassword = false;
    } else if (e.code == 'invalid-email') {
      resetPassword = false;
      showErrorDialog(
        context: context,
        title: 'Invalid email',
      );
      resetPassword = false;
    } else {
      resetPassword = false;
      showErrorDialog(
        context: context,
        title: e.code.toString(),
      );
      resetPassword = false;
    }
  }
}

void registerProcess(
  BuildContext context, {
  required String email,
  required String password,
  required String username,
}) async {
  if (username.isEmpty) {
    showErrorDialog(
      context: context,
      title: 'Username cannot be empty',
    );
    return;
  }

  try {
    // Check if the username is unique
    final usernameQuery = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();

    if (usernameQuery.docs.isNotEmpty) {
      showErrorDialog(
        context: context,
        title: 'Username already taken',
      );
      return;
    }

    // Create user with email and password
    UserCredential credentials =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Save user details
    DocumentReference users = FirebaseFirestore.instance
        .collection('users')
        .doc(credentials.user?.uid);
    await users.set({
      'username': username,
    });
    // await FirebaseAuth.instance.currentUser?.sendEmailVerification();
    pushNoReturn(context, page: const CustomizeProfileScreen());
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      showErrorDialog(
        context: context,
        title: 'Weak password',
      );
    } else if (e.code == 'email-already-in-use') {
      showErrorDialog(
        context: context,
        title: 'Email already in use',
      );
    } else if (e.code == 'invalid-email') {
      showErrorDialog(
        context: context,
        title: 'Invalid email',
      );
    } else {
      showErrorDialog(
        context: context,
        title: e.code.toString(),
      );
    }
  } catch (e) {
    showErrorDialog(
      context: context,
      title: 'An unexpected error occurred',
    );
  }
}

void signOutProcess(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  pushNoReturn(
    context,
    page: const LoginScreen(),
  );
}

Future<void> deleteAccountProcess(
  BuildContext context, {
  required User currentUser,
  required String password,
}) async {
  try {
    // Re-authenticate user before deletion
    AuthCredential credential = EmailAuthProvider.credential(
      email: currentUser.email!,
      password: password,
    );

    await currentUser.reauthenticateWithCredential(credential);

    // Construct the dynamic path using the user ID
    String userPath = 'uploads/${currentUser.uid}';

    // List all files under the user's uploads directory
    ListResult result = await FirebaseStorage.instance.ref(userPath).listAll();

    // Iterate over each item and delete it
    for (Reference fileRef in result.items) {
      await fileRef.delete();
    }

    // Delete user data from Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .delete();

    // Delete user account from authentication
    await currentUser.delete();

    // Navigate to LoginScreen
    pushNoReturn(
      context,
      page: LoginScreen(),
    );
  } on FirebaseAuthException catch (e) {
    if (e.code == 'wrong-password') {
      showErrorDialog(
        context: context,
        title: 'Incorrect password',
      );
    } else if (e.code == 'channel-error') {
      showErrorDialog(
        context: context,
        title: 'Enter your password',
      );
    }
  }
}
