import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../../../core/validators/validators.dart';
import '../../../../../../../localization/string_hardcoded.dart';
import '../../../../../../../utils/utils.dart';
import '../../../../../domain/entities/entities.dart';
import '../../../../controllers/controllers.dart';

class IncrementField extends ConsumerStatefulWidget {
  final FocusNode focusNode;
  final void Function(String) onFieldSubmitted;

  const IncrementField({
    super.key,
    required this.focusNode,
    required this.onFieldSubmitted,
  });

  @override
  ConsumerState<IncrementField> createState() => _IncrementFieldState();
}

class _IncrementFieldState extends ConsumerState<IncrementField> {
  final _incrementValueController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      _incrementValueController.text =
          ref
              .read(selectedProductStateControllerProvider)
              ?.increment
              ?.value
              ?.toString() ??
          '';

      ref
          .read(insertProductUIControllerProvider.notifier)
          .updateIncrementValue(_incrementValueController.text.toDouble() ?? 0);
    });
  }

  @override
  void dispose() {
    _incrementValueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final uiProvider = insertProductUIControllerProvider;

    final incrementType = ref.watch(uiProvider.select((s) => s.incrementType));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Acréscimo'.hardcoded,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        gapH4,
        Row(
          children: [
            Expanded(
              flex: 4,
              child: DefaultTextFormField(
                controller: _incrementValueController,
                focusNode: widget.focusNode,
                labelText: 'Valor ${incrementType.symbol}'.hardcoded,
                hintText: incrementType.symbol,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: widget.onFieldSubmitted,
                onChanged: (value) {
                  ref
                      .read(uiProvider.notifier)
                      .updateIncrementValue(double.tryParse(value) ?? 0);
                },
                validator: FormValidators.compose([
                  NumberValidator(allowDecimal: true, allowEmptyValue: true),
                ]),
              ),
            ),
            gapW8,
            Expanded(
              flex: 6,
              child: ExcludeFocus(
                child: DefaultSegmentedButtons(
                  items: PercentageOrValue.values,
                  selectedValue: incrementType,
                  onChanged: (value) =>
                      ref.read(uiProvider.notifier).updateIncrementType(value),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
