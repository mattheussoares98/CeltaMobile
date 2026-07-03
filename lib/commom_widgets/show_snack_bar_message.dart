import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

// Kept for backward compatibility — no longer used internally.
// If any call site still references scaffoldMessengerKey for the
// ScaffoldMessenger, it can safely be removed later.
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void showSnackBarMessage(
  BuildContext? context,
  String message, {
  Color? backgroundColor = Colors.green,
  Duration? duration,
}) {
  toastification.show(
    context: context?.mounted == true ? context : null,
    title: DefaultText.title(message, textAlign: TextAlign.center),
    alignment: Alignment.bottomCenter,
    autoCloseDuration: duration ?? const Duration(seconds: 4),
    backgroundColor: backgroundColor ?? Colors.green,
    foregroundColor: Colors.white,
    borderRadius: BorderRadius.circular(8),
    showProgressBar: true,
    pauseOnHover: false,
    closeOnClick: true,
    dragToClose: true,
    style: ToastificationStyle.flat,
    type: backgroundColor == Colors.red
        ? ToastificationType.error
        : ToastificationType.success,
    applyBlurEffect: false,
  );
}
