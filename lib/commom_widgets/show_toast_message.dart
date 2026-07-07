import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

// Kept for backward compatibility — no longer used internally.
// If any call site still references scaffoldMessengerKey for the
// ScaffoldMessenger, it can safely be removed later.
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

enum ToastType { error, success }

void showToastMessage(
  String message, {
  ToastType type = ToastType.success,
  Duration? duration,
}) {
  toastification.show(
    title: BaseText.title(message, textAlign: TextAlign.center),
    alignment: Alignment.bottomCenter,
    autoCloseDuration: duration ?? const Duration(seconds: 4),
    backgroundColor: type == ToastType.success ? Colors.green : Colors.red,
    foregroundColor: Colors.white,
    borderRadius: BorderRadius.circular(8),
    showProgressBar: true,
    pauseOnHover: false,
    closeOnClick: true,
    dragToClose: true,
    style: ToastificationStyle.flat,
    type: type == ToastType.success
        ? ToastificationType.success
        : ToastificationType.error,
    applyBlurEffect: false,
  );
}
