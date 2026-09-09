import 'dart:async';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/pages/components/components.dart';
import 'package:celta_inventario/utils/extensions/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PrintLabelLayoutValueAdjuster extends HookWidget {
  final String label;
  final String value;
  final num currentValue;
  final num min;
  final num max;
  final bool enabled;
  final bool? acceptDecimal;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;
  final ValueChanged<num>? onValueChanged;
  final Duration repeatInterval;

  const PrintLabelLayoutValueAdjuster({
    super.key,
    required this.label,
    required this.value,
    required this.currentValue,
    required this.min,
    this.max = double.infinity,
    this.enabled = true,
    this.acceptDecimal,
    required this.onDecrease,
    required this.onIncrease,
    this.onValueChanged,
    this.repeatInterval = const Duration(milliseconds: 75),
  });

  bool get canDecrease => enabled && currentValue > min;
  bool get canIncrease => enabled && currentValue < max;
  bool get resolvedAcceptDecimal => acceptDecimal ?? (currentValue is! int);

  @override
  Widget build(BuildContext context) {
    const debounceDuration = Duration(milliseconds: 600);
    final isEditing = useState(false);
    final textController = useTextEditingController();
    final focusNode = useFocusNode();
    final debounceTimer = useRef<Timer?>(null);
    final formKey = useMemoized(() => GlobalKey<FormState>());

    void cancelDebounce() {
      debounceTimer.value?.cancel();
      debounceTimer.value = null;
    }

    void submitText(String text) {
      if (formKey.currentState?.validate() != true) return;

      final normalized = text.trim().replaceAll(',', '.');
      final parsed = num.tryParse(normalized);
      if (parsed == null) return;

      final clamped = parsed.clamp(min, max);
      final finalValue = resolvedAcceptDecimal
          ? clamped.toDouble()
          : clamped.toInt();
      onValueChanged?.call(finalValue);
    }

    useEffect(() {
      void onFocusChange() {
        if (!focusNode.hasFocus && isEditing.value) {
          cancelDebounce();
          submitText(textController.text);
          isEditing.value = false;
        }
      }

      focusNode.addListener(onFocusChange);
      return () {
        focusNode.removeListener(onFocusChange);
        cancelDebounce();
      };
    }, [focusNode, isEditing.value]);

    void startEditing() {
      if (!enabled || onValueChanged == null) return;
      textController.text = resolvedAcceptDecimal
          ? currentValue.toString().toBrazilianNumber(2, true)
          : currentValue.toInt().toString().toBrazilianNumber();
      textController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: textController.text.length,
      );
      isEditing.value = true;
      focusNode.requestFocus();
    }

    return Column(
      children: [
        BaseText(label, overflow: TextOverflow.ellipsis),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: PrintLabelRepeatingIconButton(
                repeatInterval: repeatInterval,
                onPressed: canDecrease ? onDecrease : null,
                icon: const PlatformIcon(
                  cupertinoIcon: CupertinoIcons.minus_circle,
                  materialIcon: Icons.remove_circle_outline,
                ),
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.all(Sizes.p4),
                constraints: const BoxConstraints(),
              ),
            ),
            gapW4,
            if (isEditing.value)
              SizedBox(
                width: 60,
                child: Form(
                  key: formKey,
                  child: TextFormField(
                    controller: textController,
                    focusNode: focusNode,
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: resolvedAcceptDecimal,
                      signed: min < 0,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        resolvedAcceptDecimal
                            ? RegExp(r'^-?[0-9]*[.,]?[0-9]*')
                            : RegExp(r'^-?[0-9]*'),
                      ),
                    ],
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: Sizes.p4,
                        vertical: Sizes.p4,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (text) {
                      cancelDebounce();
                      debounceTimer.value = Timer(debounceDuration, () {
                        submitText(text);
                      });
                    },
                    validator: FormValidators.compose([
                      NumberValidator(
                        allowDecimal: acceptDecimal == true,
                        allowEmptyValue: min == 0,
                        needsBeGreaterThanZero: min > 0,
                      ),
                    ]),
                  ),
                ),
              )
            else
              GestureDetector(
                onTap: enabled && onValueChanged != null ? startEditing : null,
                child: FittedBox(
                  child: BaseText(
                    value,
                    overflow: TextOverflow.ellipsis,
                    decoration: enabled && onValueChanged != null
                        ? TextDecoration.underline
                        : null,
                  ),
                ),
              ),
            gapW4,
            Flexible(
              child: PrintLabelRepeatingIconButton(
                repeatInterval: repeatInterval,
                onPressed: canIncrease ? onIncrease : null,
                icon: const PlatformIcon(
                  cupertinoIcon: CupertinoIcons.plus_circle,
                  materialIcon: Icons.add_circle_outline,
                ),
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.all(Sizes.p4),
                constraints: const BoxConstraints(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
