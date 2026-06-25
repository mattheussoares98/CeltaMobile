import 'package:flutter/material.dart';
import 'package:celta_inventario/commom_widgets/text/text.dart';

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
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: duration ?? const Duration(seconds: 3),
        backgroundColor: backgroundColor,
        content: DefaultText(
          message,
          textAlign: TextAlign.center,
          color: Colors.white,
        ),
        dismissDirection: DismissDirection.down,
        closeIconColor: Colors.black,
      ),
    );
    return;
  }

  scaffoldMessenger.clearSnackBars();
  scaffoldMessenger.showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: duration ?? const Duration(seconds: 3),
      backgroundColor: backgroundColor,
      content: DefaultText(
        message,
        textAlign: TextAlign.center,
        color: Colors.white,
      ),
      dismissDirection: DismissDirection.down,
      closeIconColor: Colors.black,
    ),
  );
}
