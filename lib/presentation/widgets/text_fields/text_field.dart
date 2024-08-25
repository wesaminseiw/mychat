import 'package:flutter/material.dart';
import 'package:mychat/presentation/styles/colors.dart';

Widget textField({
  required BuildContext context,
  required TextEditingController controller,
  required IconData prefixIcon,
  required String hintText,
  Widget? helper,
  IconData? suffixIcon,
  Color? suffixIconColor,
  void Function()? suffixOnPressed,
  void Function()? onTap,
  void Function(String value)? onChanged,
  TextInputType? keyboardType,
  bool? obscureText,
  String? obscuringCharacter,
  int? maxLength,
}) =>
    TextField(
      controller: controller,
      style: TextStyle(
        color: secondaryColor,
      ),
      keyboardType: keyboardType ?? TextInputType.text,
      obscureText: obscureText ?? false,
      obscuringCharacter: obscuringCharacter ?? '●',
      onChanged: onChanged,
      onTap: onTap,
      maxLength: maxLength,
      cursorColor: primaryColor,
      decoration: InputDecoration(
        helper: helper,
        prefixIcon: Icon(
          prefixIcon,
          color: Colors.grey,
        ),
        suffixIcon: GestureDetector(
          onTap: suffixOnPressed ?? () {},
          child: Icon(
            suffixIcon,
            color: suffixIconColor ?? Colors.grey,
          ),
        ),
        hintText: hintText,
      ),
    );

Widget bigTextField({
  required BuildContext context,
  required TextEditingController controller,
  required IconData prefixIcon,
  required String hintText,
  IconData? suffixIcon,
  Color? suffixIconColor,
  void Function()? suffixOnPressed,
  void Function(String value)? onChanged,
  bool? obscureText,
  String? obscuringCharacter,
  int? maxLines,
}) =>
    TextField(
      controller: controller,
      style: TextStyle(
        color: secondaryColor,
      ),
      obscureText: obscureText ?? false,
      obscuringCharacter: obscuringCharacter ?? '●',
      onChanged: onChanged,
      maxLines: null,
      decoration: InputDecoration(
        prefixIcon: Icon(
          prefixIcon,
          color: Colors.grey,
        ),
        suffixIcon: GestureDetector(
          onTap: suffixOnPressed ?? () {},
          child: Icon(
            suffixIcon,
            color: suffixIconColor ?? Colors.grey,
          ),
        ),
        hintText: hintText,
      ),
    );
