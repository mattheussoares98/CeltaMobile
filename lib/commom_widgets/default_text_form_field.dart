import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../core/presentation/theme/theme.dart';

class DefaultTextFormField extends StatelessWidget {
  final bool? enabled;
  final TextEditingController controller;
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
  final int maxLength;
  const DefaultTextFormField({
    super.key,
    required this.controller,
    required this.maxLength,
    this.enabled,
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
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (theme.platform == TargetPlatform.iOS) {
      return _CupertinoFormField(
        enabled: enabled,
        controller: controller,
        onFieldSubmitted: onFieldSubmitted,
        validator: validator,
        obscureText: obscureText,
        hintText: hintText,
        labelText: labelText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        autovalidateMode: autovalidateMode,
        focusNode: focusNode,
        keyboardType: keyboardType,
        maxLength: maxLength,
      );
    }
    return TextFormField(
      enabled: enabled == false,
      controller: controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onFieldSubmitted: onFieldSubmitted,
      validator: validator,
      obscureText: obscureText,
      focusNode: focusNode,
      keyboardType: keyboardType,
      maxLength: maxLength,
      decoration: AppDecorations.input(
        context: context,
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        errorText: errorText,
      ),
    );
  }
}

class _CupertinoFormField extends StatelessWidget {
  const _CupertinoFormField({
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.prefixIcon,
    required this.suffixIcon,
    required this.validator,
    required this.obscureText,
    required this.onFieldSubmitted,
    required this.enabled,
    required this.autovalidateMode,
    required this.focusNode,
    required this.keyboardType,
    required this.maxLength,
  });

  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final bool obscureText;
  final void Function(String)? onFieldSubmitted;
  final bool? enabled;
  final AutovalidateMode? autovalidateMode;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final int maxLength;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FormField<String>(
      validator: validator,
      enabled: enabled ?? true,
      initialValue: controller?.text,
      autovalidateMode: autovalidateMode,
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CupertinoTextField(
              controller: controller,
              placeholder: labelText ?? hintText,
              placeholderStyle: theme.textTheme.bodyMedium?.copyWith(
                color: theme.disabledColor,
              ),
              obscureText: obscureText,
              onSubmitted: onFieldSubmitted,
              enabled: enabled == true,
              focusNode: focusNode,
              enableSuggestions: true,
              maxLength: maxLength,
              onChanged: (value) {
                state.didChange(value);
              },
              decoration: BoxDecoration(
                color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
                borderRadius: BorderRadius.circular(8.0),
                border: state.hasError
                    ? Border.all(color: CupertinoColors.destructiveRed)
                    : null,
              ),
              prefix: prefixIcon != null
                  ? Padding(
                      padding: const EdgeInsets.only(left: Sizes.p8),
                      child: prefixIcon,
                    )
                  : null,
              suffix: suffixIcon,
              padding: const EdgeInsets.all(Sizes.p12),
            ),

            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(left: Sizes.p8, top: Sizes.p4),
                child: Text(
                  state.errorText!,
                  style: const TextStyle(
                    color: CupertinoColors.destructiveRed,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
