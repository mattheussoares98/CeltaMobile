import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import 'form_field.dart';

class CupertinoFormField extends StatefulWidget {
  final DefaultTextFormField defaultTextFormField;

  const CupertinoFormField({super.key, required this.defaultTextFormField});

  @override
  State<CupertinoFormField> createState() => _CupertinoFormFieldState();
}

class _CupertinoFormFieldState extends State<CupertinoFormField> {
  FormFieldState<String>? _formFieldState;

  @override
  void initState() {
    super.initState();

    widget.defaultTextFormField.controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    widget.defaultTextFormField.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    if (_formFieldState?.value != widget.defaultTextFormField.controller.text) {
      _formFieldState?.didChange(widget.defaultTextFormField.controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FormField<String>(
      key: ValueKey(Random().nextDouble()),
      validator: widget.defaultTextFormField.validator,
      enabled: widget.defaultTextFormField.enabled ?? true,
      initialValue: widget.defaultTextFormField.controller.text,
      autovalidateMode: widget.defaultTextFormField.autovalidateMode,
      builder: (state) {
        _formFieldState = state;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CupertinoTextField(
              inputFormatters: widget.defaultTextFormField.inputFormatters,
              controller: widget.defaultTextFormField.controller,
              placeholder:
                  widget.defaultTextFormField.labelText ??
                  widget.defaultTextFormField.hintText,
              placeholderStyle: theme.textTheme.bodyMedium?.copyWith(
                color: theme.disabledColor,
              ),
              obscureText: widget.defaultTextFormField.obscureText,
              onSubmitted: widget.defaultTextFormField.onFieldSubmitted,
              enabled: widget.defaultTextFormField.enabled == true,
              focusNode: widget.defaultTextFormField.focusNode,
              enableSuggestions: true,
              maxLength: widget.defaultTextFormField.maxLength,
              onChanged: (value) {
                widget.defaultTextFormField.onChanged?.call(value);
                state.didChange(value);
              },
              decoration: BoxDecoration(
                color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
                borderRadius: BorderRadius.circular(8.0),
                border: state.hasError
                    ? Border.all(color: CupertinoColors.destructiveRed)
                    : null,
              ),
              prefix: widget.defaultTextFormField.prefixIcon != null
                  ? Padding(
                      padding: EdgeInsets.only(
                        left:
                            widget.defaultTextFormField.prefixIcon is IconButton
                            ? 0
                            : Sizes.p8,
                      ),
                      child: widget.defaultTextFormField.prefixIcon,
                    )
                  : null,
              suffix: widget.defaultTextFormField.suffixIcon,
              padding: EdgeInsets.all(
                widget.defaultTextFormField.prefixIcon is Icon ||
                        widget.defaultTextFormField.suffixIcon is Icon ||
                        widget.defaultTextFormField.suffixIcon == null
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
