import 'package:flutter/material.dart';
import 'package:mychat/app/utils/extensions.dart';
import 'package:mychat/app/utils/functions.dart';
import 'package:mychat/presentation/screens/search/search_screen.dart';
import 'package:mychat/presentation/styles/colors.dart';

Widget readOnlySearchBar(BuildContext context) {
  return Material(
    elevation: 7,
    borderRadius: BorderRadius.circular(50),
    child: TextField(
      style: TextStyle(
        color: primaryColor,
      ),
      textAlign: TextAlign.center,
      readOnly: true,
      onTap: () {
        push(
          context,
          page: const SearchScreen(),
        );
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: context.brightness == Brightness.light
            ? quaternaryColor
            : teritaryColor,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(50),
        ),
        hintText: 'Search..',
        hintStyle: TextStyle(
          color: Colors.grey[700],
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}
