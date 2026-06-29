import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeliveryTaxField extends ConsumerStatefulWidget {
  const DeliveryTaxField({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DeliveryTaxFieldState();
}

class _DeliveryTaxFieldState extends ConsumerState<DeliveryTaxField> {
  final _deliveryTaxValueController = TextEditingController();
  final _focusNode = FocusNode();

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
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                focusNode: _focusNode,
                controller: _deliveryTaxValueController,
                onFieldSubmitted: (_) =>
                    FocusManager.instance.primaryFocus?.nextFocus(),
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
                validator: FormValidators.compose([
                  NumberValidator(allowDecimal: true, allowEmptyValue: true),
                ]),
              ),
            ),
            gapW8,
            Expanded(
              flex: 6,
              child: ExcludeFocus(
                child: BaseSegmentedButtons(
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
