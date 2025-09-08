import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData themeData(ThemeData theme) => ThemeData(
    // * Use this to toggle Material 3 (defaults to true since Flutter 3.16)
    useMaterial3: true,
    primarySwatch: Colors.grey,
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: Colors.white,
      strokeWidth: 2,
    ),
    // platform: TargetPlatform.iOS,
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
        backgroundColor: Colors.black, // background (button) color
        foregroundColor: Colors.white, // foreground (text) color
      ),
    ),
  );
}
