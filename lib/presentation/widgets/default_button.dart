import 'package:flutter/material.dart';
import 'package:mychat/app/utils/extensions.dart';

Widget defaultButton({
  required BuildContext context,
  required double width,
  required double height,
  required Function onPressed,
  required String label,
}) =>
    SizedBox(
      width: width,
      height: height,
      child: TextButton(
        onPressed: () async {
          await onPressed();
        },
        style: TextButton.styleFrom(
          backgroundColor: context.colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label,
          style: context.textTheme.headlineSmall,
        ),
      ),
    );
