import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';

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
  final theme = Theme.of(context);
  return await showDialog(
    context: context,
    // * Only make the dialog dismissible if there is a cancel button
    barrierDismissible: cancelActionText != null,
    // * AlertDialog.adaptive was added in Flutter 3.13
    builder: (context) => AlertDialog.adaptive(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Text(title)),
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
      ),
      content: content != null
          ? SingleChildScrollView(child: Text(content))
          : null,
      // * Use [TextButton] or [CupertinoDialogAction] depending on the platform
      // https://codewithandrea.com/tips/default-target-platform/
      actions:
          kIsWeb ||
              !(theme.platform == TargetPlatform.iOS ||
                  theme.platform == TargetPlatform.macOS)
          ? <Widget>[
              if (cancelActionText != null)
                TextButton(
                  child: Text(cancelActionText),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
              TextButton(
                child: Text(defaultActionText),
                onPressed: () {
                  Navigator.of(context).pop(true);
                  onOkPressed?.call();
                },
              ),
            ]
          : <Widget>[
              if (cancelActionText != null)
                CupertinoDialogAction(
                  child: Text(cancelActionText),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
              CupertinoDialogAction(
                child: Text(defaultActionText),
                onPressed: () {
                  Navigator.of(context).pop(true);
                  onOkPressed?.call();
                },
              ),
            ],
    ),
  );
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
