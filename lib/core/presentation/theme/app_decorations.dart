import 'package:flutter/material.dart';

import '../../../constants/constants.dart';

class AppDecorations {
  static InputDecoration input({
    required BuildContext context,
    String? labelText,
    String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? errorText,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(Sizes.p12),
      borderSide: BorderSide(
        color: colorScheme.onSurface.withAlpha(75),
        width: 1,
      ),
    );

    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(Sizes.p12),
      borderSide: BorderSide(color: colorScheme.primary, width: 1),
    );

    final errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(Sizes.p12),
      borderSide: BorderSide(color: colorScheme.error, width: 1),
    );

    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      errorText: errorText,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      labelStyle: TextStyle(
        color: colorScheme.onSurface.withAlpha(200),
        fontSize: 12,
      ),
      hintStyle: TextStyle(
        color: colorScheme.onSurface.withAlpha(125),
        fontSize: 12,
      ),

      border: border,
      enabledBorder: border,
      focusedBorder: focusedBorder,
      errorBorder: errorBorder,
      focusedErrorBorder: errorBorder,
      disabledBorder: border,

      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,

      contentPadding: const EdgeInsets.all(0),

      filled: true,
      fillColor: colorScheme.surfaceContainerHighest.withAlpha(125),
    );
  }
}
