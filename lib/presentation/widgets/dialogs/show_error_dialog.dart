import 'package:flutter/material.dart';
import 'package:mychat/app/utils/functions.dart';
import 'package:mychat/presentation/styles/colors.dart';

Future<void> showErrorDialog({
  required BuildContext context,
  required String title,
}) =>
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: teritaryColor,
          title: Text(title),
          titleTextStyle: TextStyle(
            fontSize: 20,
            color: secondaryColor,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w500,
          ),
          actions: [
            TextButton(
              onPressed: () {
                pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
