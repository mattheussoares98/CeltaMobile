import 'package:flutter/material.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void showSnackBarMessage(
  BuildContext context,
  String message, {
  Color? backgroundColor = Colors.green,
  Duration? duration,
}) {
  final scaffoldMessenger = scaffoldMessengerKey.currentState;
  if (scaffoldMessenger == null) {
    if (!context.mounted) return;
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: duration ?? const Duration(seconds: 3),
        backgroundColor: backgroundColor,
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
        ),
        dismissDirection: DismissDirection.down,
        closeIconColor: Colors.black,
      ),
    );
    return;
  }

  final themeContext = scaffoldMessengerKey.currentContext ?? context;
  final theme = Theme.of(themeContext);

  scaffoldMessenger.clearSnackBars();
  scaffoldMessenger.showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: duration ?? const Duration(seconds: 3),
      backgroundColor: backgroundColor,
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
      ),
      dismissDirection: DismissDirection.down,
      closeIconColor: Colors.black,
    ),
  );
}
