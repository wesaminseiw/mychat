import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mychat/logic/services/login_register_screen_service.dart';
import 'package:mychat/presentation/styles/colors.dart';
import 'package:mychat/presentation/widgets/sized_boxes.dart';
import 'package:mychat/presentation/widgets/text_fields/text_field.dart';

Future<void> showAccountDeleteDialog({
  required BuildContext context,
  required String title,
  required User currentUser,
}) async {
  final TextEditingController passwordController = TextEditingController();

  return showDialog(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        backgroundColor: teritaryColor,
        title: Text(title),
        titleTextStyle: TextStyle(
          fontSize: 20,
          color: secondaryColor,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            height(16),
            Text(
              'This step cannot be undone',
              style: TextStyle(
                fontSize: 16,
                color: secondaryColor,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
              ),
            ),
            height(16),
            textField(
              context: ctx,
              controller: passwordController,
              prefixIcon: Icons.password_rounded,
              hintText: 'Your password',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final password = passwordController.text;
              Navigator.of(ctx).pop(); // Close the dialog

              // Call deleteAccountProcess with the user-entered password
              deleteAccountProcess(
                context,
                currentUser: currentUser,
                password: password,
              );
            },
            child: Text(
              'Delete',
              style: TextStyle(color: secondaryColor),
            ),
          ),
        ],
      );
    },
  );
}
