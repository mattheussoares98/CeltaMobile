import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData themeData(ThemeData theme) {
    const disabledColor = Colors.grey;
    const primaryColor = Colors.green;
    const primaryColorLight = Colors.lightGreenAccent;
    final primaryColorDark = Colors.green[900]!;
    const secondaryColor = Colors.blueAccent;
    const scaffoldBackgroundColor = Colors.white;

    return ThemeData(
      // * Use this to toggle Material 3 (defaults to true since Flutter 3.16)
      useMaterial3: true,
      primarySwatch: Colors.grey,
      primaryColor: primaryColor,
      primaryColorLight: primaryColorLight,
      primaryColorDark: primaryColorDark,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        backgroundColor: scaffoldBackgroundColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: disabledColor,
      ),
      colorScheme: theme.colorScheme.copyWith(
        primary: primaryColor,
        primaryContainer: primaryColorLight,
        secondary: secondaryColor,
        error: Colors.red,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryColorLight,
        refreshBackgroundColor: Colors.transparent,
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: primaryColor, // background (button) color
          foregroundColor: Colors.white, // foreground (text) color
        ),
      ),
      iconTheme: const IconThemeData(color: primaryColor),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: primaryColor,
          disabledForegroundColor: disabledColor,
        ),
      ),
    );
  }
}
