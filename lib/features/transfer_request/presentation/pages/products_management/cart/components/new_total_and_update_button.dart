import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../domain/entities/entities.dart';

class NewTotalAndUpdateButton extends StatelessWidget {
  final TextEditingController quantityController;
  final TextEditingController priceController;
  final bool requestTypeAllowChangePrice;
  final TransferRequestProductItemEntity item;
  final VoidCallback update;
  const NewTotalAndUpdateButton({
    super.key,
    required this.quantityController,
    required this.priceController,
    required this.requestTypeAllowChangePrice,
    required this.item,
    required this.update,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Listenable mergedListenable = Listenable.merge([
      quantityController,
      priceController,
    ]);

    return Column(
      children: [
        Text('Total'.hardcoded, style: theme.textTheme.titleSmall),
        AnimatedBuilder(
          animation: mergedListenable,
          builder: (_, _) {
            final writtenPrice = priceController.text.toDouble() ?? 0;
            final itemPrice = requestTypeAllowChangePrice
                ? writtenPrice
                : item.value;

            final quantity = quantityController.text.toDouble() ?? 0;
            final newValue = itemPrice * quantity;
            return RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'R\$ '.hardcoded,
                    style: theme.textTheme.titleSmall?.copyWith(fontSize: 10),
                  ),
                  TextSpan(
                    text: newValue.toString().toBrazilianNumber(),
                    style: theme.textTheme.titleMedium,
                  ),
                ],
              ),
            );
          },
        ),
        gapH8,
        PrimaryButton(text: 'Alterar'.hardcoded, onPressed: update),
      ],
    );
  }
}
