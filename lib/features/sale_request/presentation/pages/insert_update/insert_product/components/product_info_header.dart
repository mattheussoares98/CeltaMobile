import 'package:flutter/material.dart';

import '../../../../../../../constants/constants.dart';
import '../../../../../../../localization/string_hardcoded.dart';
import '../../../../../../../utils/utils.dart';
import '../../../../../domain/entities/entities.dart';

class ProductInfoHeader extends StatelessWidget {
  final BSFProductItemEntity product;

  const ProductInfoHeader({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final details = product.product;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              details?.name ?? 'Produto'.hardcoded,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            gapH8,
            if (details?.personalizedCode != null)
              _InfoRow(
                label: 'Código'.hardcoded,
                value: details!.personalizedCode!,
              ),
            if (details?.productPackingTypeString != null)
              _InfoRow(
                label: 'Embalagem'.hardcoded,
                value: details!.productPackingTypeString!,
              ),
            _InfoRow(
              label: 'Preço unitário'.hardcoded,
              value: (product.value ?? 0)
                  .toString()
                  .toBrazilianNumber()
                  .addBrazilianCoin(),
            ),
            _InfoRow(
              label: 'Quantidade'.hardcoded,
              value: (product.quantity ?? 0).toString(),
            ),
            const Divider(),
            _InfoRow(
              label: 'Total líquido'.hardcoded,
              value: product.totalLiquid
                  .toString()
                  .toBrazilianNumber()
                  .addBrazilianCoin(),
              isBold: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _InfoRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Sizes.p4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
