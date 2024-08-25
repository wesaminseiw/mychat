import 'package:flutter/material.dart';

Future push(
  BuildContext context, {
  required Widget page,
}) =>
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );

Future pushNoReturn(
  BuildContext context, {
  required Widget page,
}) =>
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ),
      (route) => false,
    );

void pop(BuildContext context) => Navigator.pop(context);

void Function() unfocus(BuildContext context) => () {
      FocusScope.of(context).unfocus();
    };
