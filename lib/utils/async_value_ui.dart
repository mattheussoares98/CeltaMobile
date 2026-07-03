import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/exceptions/exceptions.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
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

  void doOnSuccess(
    AsyncValue<void>? previous,
    VoidCallback action, {
    bool previousMustBeLoading = true,
  }) {
    if ((!previousMustBeLoading || previous is AsyncLoading) &&
        !isLoading &&
        !hasError) {
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
  }) {
    if (previous != null && previous.isLoading && !isLoading && !hasError) {
      showToastMessage(message);
    }
  }

  void showSnackbarOnError(BuildContext context, AsyncValue? previous) {
    if (previous != null && previous.isLoading && !isLoading && hasError) {
      showToastMessage(parseErrorMessage(error!), type: ToastType.error);
    }
  }
}
