import '../commom_widgets/commom_widgets.dart';
import '../exceptions/exceptions.dart';
import '/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension AsyncValueUI on AsyncValue {
  void showAlertDialogOnError(BuildContext context) {
    if (!isLoading && hasError) {
      showExceptionAlertDialog(
        context: context,
        title: 'Erro'.hardcoded,
        exception: parseErrorMessage(error!),
      );
    }
  }

  void doOnSuccess(AsyncValue<void>? previous, VoidCallback action) {
    if (previous is AsyncLoading && !isLoading && !hasError) {
      action();
    }
  }

  void showAlertDialogOnSuccess(
    BuildContext context, {
    required AsyncValue? previous,
    required String title,
    required String message,
  }) {
    if (previous is AsyncLoading && !isLoading && !hasError) {
      showAlertDialog(context: context, title: title, content: message);
    }
  }

  void showSnackbarOnSuccess(
    BuildContext context, {
    required AsyncValue? previous,
    required String message,
    Color? backgroundColor = Colors.green,
  }) {
    if (previous != null && previous.isLoading && !isLoading && !hasError) {
      showSnackBarMessage(context, message, backgroundColor: backgroundColor);
    }
  }
}
