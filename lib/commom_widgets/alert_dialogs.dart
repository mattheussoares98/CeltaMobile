import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const kDialogDefaultKey = Key('dialog-default-key');

/// Generic function to show a platform-aware Material or Cupertino dialog
Future<bool?> showAlertDialog({
  required BuildContext context,
  required String title,
  String? content,
  String? cancelActionText,
  String defaultActionText = 'OK',
  VoidCallback? onOkPressed,
}) async {
  final titleWidget = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Expanded(child: Center(child: DefaultText(title))),
      if (kDebugMode)
        IconButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: content ?? ''));
          },
          icon: const PlatformIcon(
            cupertinoIcon: CupertinoIcons.doc_on_clipboard,
            materialIcon: Icons.copy,
          ),
        ),
    ],
  );

  final contentWidget = content != null
      ? SingleChildScrollView(child: DefaultText(content))
      : null;

  if (PlatformUtil.isCupertino) {
    return await showCupertinoDialog<bool>(
      context: context,
      barrierDismissible: cancelActionText != null,
      builder: (context) => CupertinoAlertDialog(
        title: titleWidget,
        content: contentWidget,
        actions: <Widget>[
          if (cancelActionText != null)
            CupertinoDialogAction(
              child: DefaultText(cancelActionText),
              onPressed: () => Navigator.of(context).pop(false),
            ),
          CupertinoDialogAction(
            child: DefaultText(defaultActionText),
            onPressed: () {
              Navigator.of(context).pop(true);
              onOkPressed?.call();
            },
          ),
        ],
      ),
    );
  } else {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: cancelActionText != null,
      builder: (context) => AlertDialog(
        title: titleWidget,
        content: contentWidget,
        actions: <Widget>[
          if (cancelActionText != null)
            TextButton(
              child: DefaultText(cancelActionText),
              onPressed: () => Navigator.of(context).pop(false),
            ),
          TextButton(
            child: DefaultText(defaultActionText),
            onPressed: () {
              Navigator.of(context).pop(true);
              onOkPressed?.call();
            },
          ),
        ],
      ),
    );
  }
}

/// Generic function to show a platform-aware Material or Cupertino error dialog
Future<bool?> showExceptionAlertDialog({
  required BuildContext context,
  required String title,
  required dynamic exception,
}) async => await showAlertDialog(
  context: context,
  title: title,
  content: exception.toString(),
  defaultActionText: 'OK'.hardcoded,
);

Future<bool?> showNotImplementedAlertDialog({
  required BuildContext context,
}) async =>
    await showAlertDialog(context: context, title: 'Not implemented'.hardcoded);
