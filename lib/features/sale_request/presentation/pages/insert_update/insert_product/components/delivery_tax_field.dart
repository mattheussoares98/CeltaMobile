import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/localization.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeliveryTaxField extends ConsumerWidget {
  final FocusNode focusNode;
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final void Function(String)? onFieldSubmitted;

  const DeliveryTaxField({
    super.key,
    required this.focusNode,
    required this.controller,
    this.textInputAction = TextInputAction.next,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = ref.watch(currentProductItemProvider);
    final uiProvider = insertProductUIControllerProvider(product);

    final uiState = ref.watch(uiProvider);
    final item = uiState.applyTo(product);

    final deliveryTaxType = uiState.deliveryTaxType;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: context.theme.textTheme.titleSmall,
            children: [
              TextSpan(text: 'Taxa de entrega'.hardcoded),
              TextSpan(
                text:
                    ' (${item.totalDeliveryTax.toString().toBrazilianNumber().addBrazilianCoin()})',
                style: context.theme.textTheme.labelMedium?.copyWith(
                  color: context.theme.colorScheme.secondary,
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
              child: BaseTextFormField(
                focusNode: focusNode,
                controller: controller,
                onFieldSubmitted: onFieldSubmitted,
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
                textInputAction: textInputAction,
                validator: FormValidators.compose([
                  NumberValidator(
                    translations: context.l10n,
                    allowDecimal: true,
                    allowEmptyValue: true,
                  ),
                ]),
              ),
            ),
            gapW8,
            Expanded(
              flex: 6,
              child: ExcludeFocus(
                child: BaseSegmentedButtons<PercentageOrValue>(
                  items: PercentageOrValue.values,
                  selectedValue: deliveryTaxType,
                  itemLabelBuilder: (item) => item.name,
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
