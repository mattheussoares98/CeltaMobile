import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/exceptions/exceptions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'commom_widgets.dart';

const kDialogDefaultKey = Key('dialog-default-key');

/// Generic function to show a platform-aware Material or Cupertino dialog
Future<bool?> showAlertDialog({
  required BuildContext context,
  required String title,
  String? content,
  Widget? contentWidget,
  String? cancelActionText,
  String? defaultActionText,
  List<Widget>? actions,
  VoidCallback? onLongpressTitle,
}) {
  return showDialog<bool>(
    context: context,
    // Only make the dialog dismissible if there is a cancel button
    barrierDismissible: cancelActionText != null,
    builder: (context) => AlertDialog.adaptive(
      key: kDialogDefaultKey,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: GestureDetector(
              onLongPress: onLongpressTitle,
              child: Text(title),
            ),
          ),
          if (kDebugMode && (content?.isNotEmpty ?? false))
            IconButton(
              onPressed: () => Clipboard.setData(ClipboardData(text: content!)),
              icon: const PlatformIcon(
                cupertinoIcon: CupertinoIcons.doc_on_clipboard,
                materialIcon: Icons.copy,
              ),
            ),
        ],
      ),
      content:
          contentWidget ??
          (content != null
              ? SingleChildScrollView(child: Text(content))
              : null),
      actions:
          actions ??
          (PlatformUtil.isCupertino
              ? <Widget>[
                  if (cancelActionText != null)
                    CupertinoDialogAction(
                      child: Text(cancelActionText),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                  CupertinoDialogAction(
                    child: Text(defaultActionText ?? context.l10n.ok),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                ]
              : <Widget>[
                  if (cancelActionText != null)
                    TextButton(
                      child: Text(cancelActionText),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                  TextButton(
                    child: Text(defaultActionText ?? context.l10n.ok),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                ]),
    ),
  );
}

/// Generic function to show a platform-aware Material or Cupertino error dialog
Future<bool?> showExceptionAlertDialog({
  required BuildContext context,
  required String title,
  required dynamic exception,
}) => showAlertDialog(
  context: context,
  title: title,
  content: parseErrorMessage(exception, translations: context.l10n),
);
