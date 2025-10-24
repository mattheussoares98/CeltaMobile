import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/presentation/theme/theme.dart';
import 'form_field.dart';

class DefaultTextFormField extends StatelessWidget {
  final bool? enabled;
  final TextEditingController? controller;
  final void Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;
  final String? labelText;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? errorText;
  final bool obscureText;
  final AutovalidateMode? autovalidateMode;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final int? maxLength;
  final Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final VoidCallback? onTap;
  final int? maxLines;
  const DefaultTextFormField({
    super.key,
    this.maxLength,
    this.controller,
    this.enabled = true,
    this.onFieldSubmitted,
    this.validator,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.errorText,
    this.autovalidateMode,
    this.focusNode,
    this.keyboardType,
    this.onChanged,
    this.inputFormatters,
    this.onTap,
    this.maxLines,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (theme.platform == TargetPlatform.iOS) {
      return Padding(
        padding: const EdgeInsets.only(top: 4),
        child: CupertinoFormField(defaultTextFormField: this),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: TextFormField(
        key: ValueKey(Random().nextDouble()),
        minLines: 1,
        maxLines: maxLines ?? 1,
        enabled: enabled,
        controller: controller,
        autovalidateMode: autovalidateMode,
        onFieldSubmitted: onFieldSubmitted,
        inputFormatters: inputFormatters,
        validator: validator,
        obscureText: obscureText,
        focusNode: focusNode,
        keyboardType: keyboardType,
        maxLength: maxLength,
        onChanged: onChanged,
        onTap: onTap,
        buildCounter:
            (
              context, {
              required currentLength,
              required isFocused,
              required maxLength,
            }) => null,
        decoration: AppDecorations.input(
          enabled: enabled ?? true,
          context: context,
          labelText: labelText,
          hintText: hintText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          errorText: errorText,
          isMultiLine: (maxLines ?? 1) > 1,
        ),
      ),
    );
  }
}
