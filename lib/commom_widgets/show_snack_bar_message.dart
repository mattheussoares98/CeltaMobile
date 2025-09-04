import 'package:flutter/material.dart';

void showSnackBarMessage(
  BuildContext context,
  String message, {
  Color? backgroundColor = Colors.green,
  Duration? duration,
}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: duration ?? const Duration(seconds: 2),
      backgroundColor: backgroundColor,
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white,
            ),
      ),
      dismissDirection: DismissDirection.down,
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      closeIconColor: Colors.black,
      // margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 50),
      // behavior: SnackBarBehavior.floating,
    ),
  );
}
