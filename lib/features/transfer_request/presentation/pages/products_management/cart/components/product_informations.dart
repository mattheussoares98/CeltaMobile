import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/transfer_request/domain/entities/entities.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
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
        TitleAndSubTitle(title: 'PLU'.hardcoded, subTitle: item.product.PLU),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(
              child: _ColumnTitleAndValue(
                title: 'Qtd'.hardcoded,
                value: item.quantity,
                isPrice: false,
              ),
            ),
            Expanded(
              child: _ColumnTitleAndValue(
                title: 'Preço'.hardcoded,
                value: item.value,
                isPrice: true,
              ),
            ),
            Flexible(
              child: _ColumnTitleAndValue(
                title: 'Total'.hardcoded,
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
                  text: "R\$ ".hardcoded,
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
