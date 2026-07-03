import 'package:celta_inventario/commom_widgets/text/text.dart';
import 'package:flutter/material.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void showSnackBarMessage(
  BuildContext? context,
  String message, {
  Color? backgroundColor = Colors.green,
  Duration? duration,
}) {
  // Always prefer the global key (attached to MaterialApp root).
  // This works on iOS where CupertinoPageScaffold is used and
  // ScaffoldMessenger.maybeOf(context) would return null.
  final scaffoldMessenger =
      scaffoldMessengerKey.currentState ??
      (context != null && context.mounted
          ? ScaffoldMessenger.maybeOf(context)
          : null);
  if (scaffoldMessenger == null) return;

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
