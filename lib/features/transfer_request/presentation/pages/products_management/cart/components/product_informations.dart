import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/transfer_request/domain/entities/entities.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';

class ProductInformations extends StatelessWidget {
  final TransferRequestProductItemEntity item;
  const ProductInformations({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleAndSubTitle(
          title: item.product.Name,
          subTitle: " (${item.product.PackingQuantity!.formattedPacking()})",
          titleStyle: context.theme.textTheme.titleMedium,
          subTitleStyle: context.theme.textTheme.bodyMedium,
        ),
        TitleAndSubTitle(title: context.l10n.plu, subTitle: item.product.PLU),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(
              child: _ColumnTitleAndValue(
                title: context.l10n.quantityShort,
                value: item.quantity,
                isPrice: false,
              ),
            ),
            Expanded(
              child: _ColumnTitleAndValue(
                title: context.l10n.price,
                value: item.value,
                isPrice: true,
              ),
            ),
            Flexible(
              child: _ColumnTitleAndValue(
                title: context.l10n.total,
                value: item.quantity * item.value,
                isPrice: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ColumnTitleAndValue extends StatelessWidget {
  final String title;
  final double value;
  final bool isPrice;
  const _ColumnTitleAndValue({
    required this.title,
    required this.value,
    required this.isPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: context.theme.textTheme.titleSmall?.copyWith(
            color: context.theme.disabledColor,
          ),
        ),
        RichText(
          text: TextSpan(
            children: [
              if (isPrice)
                TextSpan(
                  text: "R\$ ",
                  style: context.theme.textTheme.bodySmall?.copyWith(
                    fontSize: 10,
                  ),
                ),
              TextSpan(
                text: value.toString().toBrazilianNumber(2, !isPrice),
                style: context.theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
