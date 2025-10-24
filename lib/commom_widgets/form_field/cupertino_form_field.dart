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

    widget.defaultTextFormField.controller?.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    widget.defaultTextFormField.controller?.removeListener(
      _onControllerChanged,
    );
    super.dispose();
  }

  void _onControllerChanged() {
    if (_formFieldState?.value !=
        widget.defaultTextFormField.controller?.text) {
      _formFieldState?.didChange(widget.defaultTextFormField.controller?.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dtf = widget.defaultTextFormField;

    return FormField<String>(
      key: ValueKey(Random().nextDouble()),
      validator: dtf.validator,
      enabled: dtf.enabled ?? true,
      initialValue: dtf.controller?.text,
      autovalidateMode: dtf.autovalidateMode,
      builder: (state) {
        _formFieldState = state;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (dtf.labelText != null)
              Padding(
                padding: const EdgeInsets.only(
                  left: Sizes.p8,
                  bottom: Sizes.p4,
                ),
                child: Text(
                  dtf.labelText!,
                  style: CupertinoTheme.of(context).textTheme.textStyle
                      .copyWith(color: theme.disabledColor, fontSize: 12),
                ),
              ),
            CupertinoTextField(
              onTap: dtf.onTap,
              inputFormatters: dtf.inputFormatters,
              controller: dtf.controller,
              minLines: 1,
              maxLines: dtf.maxLines ?? 1,
              placeholder: dtf.labelText ?? dtf.hintText,
              placeholderStyle: theme.textTheme.bodyMedium?.copyWith(
                color: theme.disabledColor,
              ),
              obscureText: dtf.obscureText,
              onSubmitted: dtf.onFieldSubmitted,
              enabled: dtf.enabled == true,
              focusNode: dtf.focusNode,
              enableSuggestions: true,
              maxLength: dtf.maxLength,
              onChanged: (value) {
                dtf.onChanged?.call(value);
                state.didChange(value);
              },
              decoration: BoxDecoration(
                color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
                borderRadius: BorderRadius.circular(Sizes.p8),
                border: state.hasError
                    ? Border.all(color: CupertinoColors.destructiveRed)
                    : null,
              ),
              prefix: dtf.prefixIcon != null
                  ? Padding(
                      padding: EdgeInsets.only(
                        left: dtf.prefixIcon is IconButton ? 0 : Sizes.p8,
                      ),
                      child: dtf.prefixIcon,
                    )
                  : null,
              suffix: dtf.suffixIcon,
              padding: EdgeInsets.all(
                dtf.prefixIcon is Icon ||
                        dtf.suffixIcon is Icon ||
                        dtf.suffixIcon == null
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
                    fontSize: Sizes.p12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
