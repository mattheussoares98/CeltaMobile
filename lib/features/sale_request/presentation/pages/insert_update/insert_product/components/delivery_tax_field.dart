import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../../../core/validators/validators.dart';
import '../../../../../../../localization/string_hardcoded.dart';
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
        _deliveryTaxValueController.text =
            product.deliveryTax?.value?.toString() ?? '';
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

    final deliveryTaxType = ref.watch(
      uiProvider.select((s) => s.deliveryTaxType),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Taxa de entrega'.hardcoded,
          style: Theme.of(context).textTheme.titleSmall,
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
