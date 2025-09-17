import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData themeData(ThemeData theme) {
    final disabledColor = Colors.grey;
    final primaryColor = Colors.green;
    final primaryColorLight = Colors.lightGreenAccent;
    final primaryColorDark = Colors.green[900]!;
    final secondaryColor = Colors.amber;

    return ThemeData(
      // * Use this to toggle Material 3 (defaults to true since Flutter 3.16)
      useMaterial3: true,
      primarySwatch: Colors.grey,
      primaryColor: primaryColor,
      primaryColorLight: primaryColorLight,
      primaryColorDark: primaryColorDark,
      colorScheme: theme.colorScheme.copyWith(
        primary: primaryColor,
        primaryContainer: primaryColorLight,
        secondary: secondaryColor,
        error: Colors.red,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: disabledColor,
        strokeWidth: 2,
      ),
      platform: TargetPlatform.iOS,
      textTheme: TextTheme(
        titleLarge: theme.textTheme.titleLarge!.copyWith(
          fontWeight: FontWeight.bold,
        ),
        titleMedium: theme.textTheme.titleMedium!.copyWith(
          fontWeight: FontWeight.bold,
        ),
        titleSmall: theme.textTheme.titleSmall!.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      appBarTheme: const AppBarTheme(
        // backgroundColor: Colors.black87,
        // foregroundColor: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor, // background (button) color
          foregroundColor: Colors.white, // foreground (text) color
        ),
      ),
      iconTheme: IconThemeData(color: primaryColor),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: primaryColor,
          disabledForegroundColor: disabledColor,
        ),
      ),
    );
  }
}
