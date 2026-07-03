import 'package:celta_inventario/commom_widgets/form_field/form_field.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/keyboard/keyboard/keyboard.dart';
import 'package:celta_inventario/core/providers/services/services.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CupertinoFormField extends ConsumerStatefulWidget {
  final BaseTextFormField defaultTextFormField;

  const CupertinoFormField({super.key, required this.defaultTextFormField});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CupertinoFormFieldState();
}

class _CupertinoFormFieldState extends ConsumerState<CupertinoFormField> {
  FormFieldState<String>? _formFieldState;
  final overlayManager = OverlayManager();

  @override
  void initState() {
    super.initState();

    widget.defaultTextFormField.focusNode?.addListener(_updateOverlayState);
    widget.defaultTextFormField.controller?.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    widget.defaultTextFormField.focusNode?.removeListener(_updateOverlayState);
    widget.defaultTextFormField.controller?.removeListener(
      _onControllerChanged,
    );
    overlayManager.hide();
    super.dispose();
  }

  void _onControllerChanged() {
    if (_formFieldState?.value !=
        widget.defaultTextFormField.controller?.text) {
      _formFieldState?.didChange(widget.defaultTextFormField.controller?.text);
    }
  }

  void _updateOverlayState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 100));
      if (!mounted) return;
      final dtf = widget.defaultTextFormField;
      final hasFocus = dtf.focusNode?.hasFocus ?? false;
      final isKeyboardOpen = ref.read(
        keyboardVisibilityStateControllerProvider,
      );

      if (hasFocus && isKeyboardOpen && isNumeric) {
        debugPrint('show');
        _showOverlay();
      } else if (!hasFocus) {
        debugPrint('Hide');
        overlayManager.hide();
      }
    });
  }

  void _showOverlay() {
    final dtf = widget.defaultTextFormField;
    overlayManager.showDoneBar(
      context: context,
      focusNode: dtf.focusNode,
      onDone: () {
        if (dtf.onFieldSubmitted != null) {
          dtf.onFieldSubmitted?.call(dtf.controller?.text ?? '');
        } else if (dtf.onEditingComplete != null) {
          dtf.onEditingComplete?.call();
        } else {
          dtf.focusNode?.unfocus();
        }
      },
    );
  }

  bool get isNumeric =>
      widget.defaultTextFormField.keyboardType == TextInputType.number ||
      widget.defaultTextFormField.keyboardType ==
          const TextInputType.numberWithOptions(decimal: true) ||
      widget.defaultTextFormField.keyboardType ==
          const TextInputType.numberWithOptions();

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    final dtf = widget.defaultTextFormField;
    final isEnabled = dtf.enabled ?? true;

    if (dtf.focusNode == null &&
        (dtf.keyboardType == TextInputType.number ||
            dtf.keyboardType ==
                const TextInputType.numberWithOptions(decimal: true))) {
      ref.read(crashlyticsServiceProvider).setCustomKeys([
        const CrashlyticsCustomKeyEntity(
          key: 'iOS numeric keyboard without focus node',
          value:
              'iOS device with numeric keyboard and no focus node. This is a problem to manage the overlay with the done button. Please, add a focus node to this text field.',
        ),
      ]);
    }

    return FormField<String>(
      key: dtf.key,
      validator: dtf.validator,
      enabled: isEnabled,
      initialValue: dtf.controller?.text,
      autovalidateMode: dtf.autovalidateMode,
      builder: (state) {
        _formFieldState = state;

        final fillColor = isEnabled
            ? CupertinoColors.tertiarySystemFill.resolveFrom(context)
            : colorScheme.onSurface.withAlpha(25);

        final Border? border = state.hasError
            ? Border.all(color: CupertinoColors.destructiveRed)
            : !isEnabled
            ? Border.all(color: colorScheme.onSurface.withAlpha(20))
            : null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (dtf.labelText != null)
              Padding(
                padding: const EdgeInsets.only(left: Sizes.p8),
                child: Text(
                  dtf.labelText!,
                  style: TextStyle(
                    color: isEnabled
                        ? colorScheme.onSurface.withAlpha(200)
                        : colorScheme.onSurface.withAlpha(100),
                    fontSize: 12,
                  ),
                ),
              ),
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: Sizes.p48),
              child: CupertinoTextField(
                scrollPadding: const EdgeInsets.all(Sizes.p120),
                onTap: dtf.onTap,
                onEditingComplete: dtf.onEditingComplete,
                inputFormatters: dtf.inputFormatters,
                controller: dtf.controller,
                textInputAction: dtf.textInputAction,
                minLines: 1,
                maxLines: dtf.maxLines ?? 1,
                placeholder: dtf.hintText,
                autofocus: dtf.autofocus == true,
                style: TextStyle(
                  color: isEnabled
                      ? null
                      : colorScheme.onSurface.withAlpha(100),
                ),
                placeholderStyle: context.theme.textTheme.bodyMedium?.copyWith(
                  color: isEnabled
                      ? colorScheme.onSurface.withAlpha(125)
                      : colorScheme.onSurface.withAlpha(100),
                  fontSize: 12,
                ),
                textAlignVertical: TextAlignVertical.center,
                obscureText: dtf.obscureText,
                onSubmitted: dtf.onFieldSubmitted,
                enabled: isEnabled,
                focusNode: dtf.focusNode,
                enableSuggestions: true,
                maxLength: dtf.maxLength,
                autofillHints: dtf.autofillHints,
                onChanged: (value) {
                  dtf.onChanged?.call(value);
                  state.didChange(value);
                },
                decoration: BoxDecoration(
                  color: fillColor,
                  borderRadius: BorderRadius.circular(Sizes.p8),
                  border: border,
                ),
                keyboardType: dtf.keyboardType,
                prefix: dtf.prefixIcon == null
                    ? null
                    : _BuildIcon(widget: dtf.prefixIcon!),
                suffix: dtf.suffixIcon == null
                    ? null
                    : _BuildIcon(widget: dtf.suffixIcon!),
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

class _BuildIcon extends StatelessWidget {
  final Widget widget;
  const _BuildIcon({required this.widget});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minWidth: Sizes.p48,
        minHeight: Sizes.p48,
      ),
      child: Center(child: widget),
    );
  }
}
