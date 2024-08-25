import 'package:flutter/material.dart';
import 'package:mychat/presentation/styles/colors.dart';

ThemeData lightTheme() => ThemeData(
      fontFamily: 'Montserrat',
      scaffoldBackgroundColor: teritaryColor,
      appBarTheme: AppBarTheme(
        backgroundColor: teritaryColor,
        titleTextStyle: TextStyle(
          color: primaryColor,
          fontFamily: 'Montserrat',
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
      ),
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: teritaryColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: quaternaryColor,
        hintStyle: TextStyle(
          color: Colors.grey[600],
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 96.0,
          fontWeight: FontWeight.bold,
          color: teritaryColor,
        ),
        displayMedium: TextStyle(
          fontSize: 60.0,
          fontWeight: FontWeight.bold,
          color: teritaryColor,
        ),
        displaySmall: TextStyle(
          fontSize: 48.0,
          fontWeight: FontWeight.bold,
          color: teritaryColor,
        ),
        headlineLarge: TextStyle(
          fontSize: 40.0,
          fontWeight: FontWeight.bold,
          color: teritaryColor,
        ),
        headlineMedium: TextStyle(
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
          color: teritaryColor,
        ),
        headlineSmall: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: teritaryColor,
        ),
        titleLarge: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w500,
          color: teritaryColor,
        ),
        titleMedium: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w500,
          color: teritaryColor,
        ),
        titleSmall: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
          color: teritaryColor,
        ),
        bodyLarge: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.normal,
          color: teritaryColor,
        ),
        bodyMedium: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.normal,
          color: teritaryColor,
        ),
        bodySmall: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.normal,
          color: teritaryColor,
        ),
        labelLarge: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
          color: teritaryColor,
        ),
        labelMedium: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
          color: teritaryColor,
        ),
        labelSmall: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          color: teritaryColor,
        ),
      ),
    );

ThemeData darkTheme() => ThemeData(
      fontFamily: 'Montserrat',
      scaffoldBackgroundColor: primaryColor,
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        titleTextStyle: TextStyle(
          color: teritaryColor,
          fontFamily: 'Montserrat',
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
      ),
      colorScheme: ColorScheme.dark(
        primary: teritaryColor,
        secondary: secondaryColor,
        surface: primaryColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: teritaryColor,
        hintStyle: TextStyle(
          color: Colors.grey[600],
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 96.0,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
        displayMedium: TextStyle(
          fontSize: 60.0,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
        displaySmall: TextStyle(
          fontSize: 48.0,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
        headlineLarge: TextStyle(
          fontSize: 40.0,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
        headlineMedium: TextStyle(
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
        headlineSmall: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
        titleLarge: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w500,
          color: primaryColor,
        ),
        titleMedium: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w500,
          color: primaryColor,
        ),
        titleSmall: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
          color: primaryColor,
        ),
        bodyLarge: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.normal,
          color: primaryColor,
        ),
        bodyMedium: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.normal,
          color: primaryColor,
        ),
        bodySmall: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.normal,
          color: primaryColor,
        ),
        labelLarge: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
          color: primaryColor,
        ),
        labelMedium: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
          color: primaryColor,
        ),
        labelSmall: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          color: primaryColor,
        ),
      ),
    );
