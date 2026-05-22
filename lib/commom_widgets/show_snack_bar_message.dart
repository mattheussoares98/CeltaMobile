import 'package:celta_inventario/utils/utils.dart';
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
      behavior: SnackBarBehavior.floating,
      duration: duration ?? const Duration(seconds: 3),
      backgroundColor: backgroundColor,
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: context.theme
            .textTheme
            .bodyMedium
            ?.copyWith(color: Colors.white),
      ),
      dismissDirection: DismissDirection.down,
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      closeIconColor: Colors.black,
      // margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 50),
      // behavior: SnackBarBehavior.floating,
    ),
  );
}
