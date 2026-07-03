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

  // Compute the current keyboard height so the snackbar always floats
  // above it. Prefer the caller's context; fall back to the global key's
  // context (which is inside MaterialApp and has the same MediaQuery data).
  final resolvedContext = (context != null && context.mounted)
      ? context
      : scaffoldMessengerKey.currentContext;
  final keyboardHeight = resolvedContext != null && resolvedContext.mounted
      ? MediaQuery.viewInsetsOf(resolvedContext).bottom
      : 0.0;

  scaffoldMessenger.clearSnackBars();
  scaffoldMessenger.showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: keyboardHeight > 0 ? keyboardHeight + 8 : 8,
      ),
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
