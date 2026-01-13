import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../localization/string_hardcoded.dart';
import '../../../../../../utils/utils.dart';
import '../../../../domain/entities/entities.dart';
import '../../../controllers/controllers.dart';

class TotalPrice extends ConsumerWidget {
  final TextEditingController quantityController;
  final TextEditingController priceController;
  final double price;
  final DraftKey draftKey;

  const TotalPrice({
    super.key,
    required this.quantityController,
    required this.priceController,
    required this.price,
    required this.draftKey,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final requestTypeAllowChangePrice = ref.watch(
      uiStateControllerProvider(
        draftKey.requestTypeCode,
      ).select((s) => s.value?.requestTypeAllowChangePrice ?? false),
    );

    return Column(
      children: [
        Text('Total'.hardcoded, style: theme.textTheme.titleSmall),
        AnimatedBuilder(
          animation: Listenable.merge([quantityController, priceController]),
          builder: (_, _) {
            final writtenPrice = priceController.text.toDouble() ?? 0;
            final itemPrice = requestTypeAllowChangePrice
                ? writtenPrice
                : price;

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
      ],
    );
  }
}
