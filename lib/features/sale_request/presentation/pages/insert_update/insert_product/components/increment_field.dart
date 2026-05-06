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
  const IncrementField({super.key});

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
      final product = ref.read(currentProductItemProvider);
      final incrementValue = product.increment?.value ?? 0;

      if (incrementValue <= 0) return;
      _incrementValueController.text = incrementValue
          .toString()
          .toBrazilianNumber();
    });
  }

  @override
  void dispose() {
    _incrementValueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = ref.watch(currentProductItemProvider);
    final uiProvider = insertProductUIControllerProvider(product);

    final uiState = ref.watch(uiProvider);
    final item = uiState.applyTo(product);
    final theme = Theme.of(context);

    final incrementType = uiState.incrementType;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: theme.textTheme.titleSmall,
            children: [
              TextSpan(text: 'Acréscimo'.hardcoded),
              TextSpan(
                text:
                    ' (${item.totalIncrement.toString().toBrazilianNumber().addBrazilianCoin()})',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        gapH4,
        Row(
          children: [
            Expanded(
              flex: 4,
              child: DefaultTextFormField(
                controller: _incrementValueController,
                labelText: 'Valor ${incrementType.symbol}'.hardcoded,
                hintText: incrementType.symbol,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textInputAction: TextInputAction.next,
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
