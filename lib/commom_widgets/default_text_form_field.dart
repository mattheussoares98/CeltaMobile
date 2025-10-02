import 'dart:math';

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
  final Function(String)? onChanged;
  const DefaultTextFormField({
    super.key,
    required this.controller,
    required this.maxLength,
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
        onChanged: onChanged,
      );
    }
    return TextFormField(
      key: ValueKey(Random().nextDouble()),
      enabled: enabled,
      controller: controller,
      autovalidateMode: autovalidateMode,
      onFieldSubmitted: onFieldSubmitted,
      validator: validator,
      obscureText: obscureText,
      focusNode: focusNode,
      keyboardType: keyboardType,
      maxLength: maxLength,
      onChanged: onChanged,
      buildCounter:
          (
            context, {
            required currentLength,
            required isFocused,
            required maxLength,
          }) => null,
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

class _CupertinoFormField extends StatefulWidget {
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
  final Function(String)? onChanged;

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
    required this.onChanged,
  });

  @override
  State<_CupertinoFormField> createState() => _CupertinoFormFieldState();
}

class _CupertinoFormFieldState extends State<_CupertinoFormField> {
  FormFieldState<String>? _formFieldState;

  @override
  void initState() {
    super.initState();

    widget.controller?.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    if (_formFieldState?.value != widget.controller?.text) {
      _formFieldState?.didChange(widget.controller?.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FormField<String>(
      key: ValueKey(Random().nextDouble()),
      validator: widget.validator,
      enabled: widget.enabled ?? true,
      initialValue: widget.controller?.text,
      autovalidateMode: widget.autovalidateMode,
      builder: (state) {
        _formFieldState = state;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CupertinoTextField(
              controller: widget.controller,
              placeholder: widget.labelText ?? widget.hintText,
              placeholderStyle: theme.textTheme.bodyMedium?.copyWith(
                color: theme.disabledColor,
              ),
              obscureText: widget.obscureText,
              onSubmitted: widget.onFieldSubmitted,
              enabled: widget.enabled == true,
              focusNode: widget.focusNode,
              enableSuggestions: true,
              maxLength: widget.maxLength,
              onChanged: (value) {
                widget.onChanged?.call(value);
                state.didChange(value);
              },
              decoration: BoxDecoration(
                color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
                borderRadius: BorderRadius.circular(8.0),
                border: state.hasError
                    ? Border.all(color: CupertinoColors.destructiveRed)
                    : null,
              ),
              prefix: widget.prefixIcon != null
                  ? Padding(
                      padding: EdgeInsets.only(
                        left: widget.prefixIcon is IconButton ? 0 : Sizes.p8,
                      ),
                      child: widget.prefixIcon,
                    )
                  : null,
              suffix: widget.suffixIcon,
              padding: EdgeInsets.all(
                widget.prefixIcon is Icon ||
                        widget.suffixIcon is Icon ||
                        widget.suffixIcon == null
                    ? Sizes.p12
                    : 0,
              ),
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
