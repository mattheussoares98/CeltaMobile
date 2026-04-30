import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../../../core/validators/validators.dart';
import '../../../../../../../localization/string_hardcoded.dart';
import '../../../../../domain/entities/entities.dart';
import '../../../../controllers/controllers.dart';

class DeliveryTaxField extends ConsumerStatefulWidget {
  final FocusNode focusNode;

  const DeliveryTaxField({
    super.key,
    required this.focusNode,
  });

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
      if (!mounted) return;
      _deliveryTaxValueController.text =
          ref
              .read(selectedProductStateControllerProvider)
              ?.deliveryTax
              ?.value
              ?.toString() ??
          '';

      ref
          .read(insertProductUIControllerProvider.notifier)
          .updateDeliveryTaxValue(
            double.tryParse(_deliveryTaxValueController.text) ?? 0,
          );
    });
  }

  @override
  void dispose() {
    _deliveryTaxValueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final uiProvider = insertProductUIControllerProvider;

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
                focusNode: widget.focusNode,
                labelText: 'Valor ${deliveryTaxType.symbol}'.hardcoded,
                hintText: deliveryTaxType.symbol,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
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
                  onChanged: (value) =>
                      ref.read(uiProvider.notifier).updateDeliveryTaxType(value),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
