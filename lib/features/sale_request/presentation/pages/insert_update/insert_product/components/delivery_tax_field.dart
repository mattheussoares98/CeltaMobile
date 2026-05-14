import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../../../core/validators/validators.dart';
import '../../../../../../../localization/string_hardcoded.dart';
import '../../../../../../../utils/utils.dart';
import '../../../../../domain/entities/entities.dart';
import '../../../../controllers/controllers.dart';

class DeliveryTaxField extends ConsumerStatefulWidget {
  const DeliveryTaxField({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DeliveryTaxFieldState();
}

class _DeliveryTaxFieldState extends ConsumerState<DeliveryTaxField> {
  final _deliveryTaxValueController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        final product = ref.read(currentProductItemProvider);
        final deliveryTax = product.deliveryTax?.value ?? 0;

        if (deliveryTax <= 0) return;

        _deliveryTaxValueController.text = deliveryTax
            .toString()
            .toBrazilianNumber();
      }
    });
  }

  @override
  void dispose() {
    _deliveryTaxValueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = ref.watch(currentProductItemProvider);
    final uiProvider = insertProductUIControllerProvider(product);

    final uiState = ref.watch(uiProvider);
    final item = uiState.applyTo(product);
    final theme = Theme.of(context);

    final deliveryTaxType = uiState.deliveryTaxType;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: theme.textTheme.titleSmall,
            children: [
              TextSpan(text: 'Taxa de entrega'.hardcoded),
              TextSpan(
                text:
                    ' (${item.totalDeliveryTax.toString().toBrazilianNumber().addBrazilianCoin()})',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.secondary,
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
                controller: _deliveryTaxValueController,
                labelText: 'Valor ${deliveryTaxType.symbol}'.hardcoded,
                hintText: deliveryTaxType.symbol,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onChanged: (value) {
                  ref
                      .read(uiProvider.notifier)
                      .updateDeliveryTaxValue(double.tryParse(value) ?? 0);
                },
                textInputAction: TextInputAction.next,
                //TODO use focus nodes instead
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
                  selectedValue: deliveryTaxType,
                  onChanged: (value) => ref
                      .read(uiProvider.notifier)
                      .updateDeliveryTaxType(value),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
