import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../localization/string_hardcoded.dart';
import '../../../../../../../utils/utils.dart';
import '../../../../controllers/controllers.dart';
import './components.dart';

class TotalPrice extends ConsumerWidget {
  final ProductItem widget;
  const TotalPrice({super.key, required this.widget});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final requestTypeAllowChangePrice = ref.watch(
      uiStateControllerProvider(
        widget.draftKey.requestTypeCode,
      ).select((s) => s.value?.requestTypeAllowChangePrice ?? false),
    );

    return Column(
      children: [
        Text('Total'.hardcoded, style: theme.textTheme.titleSmall),
        AnimatedBuilder(
          animation: Listenable.merge([
            widget.quantityController,
            widget.priceController,
          ]),
          builder: (_, _) {
            final writtenPrice = widget.priceController.text.toDouble() ?? 0;
            final itemPrice = requestTypeAllowChangePrice
                ? writtenPrice
                : widget.item.value;

            final quantity = widget.quantityController.text.toDouble() ?? 0;
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
