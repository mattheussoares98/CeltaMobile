import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/entities.dart';
import 'components.dart';

class PricesTypesWidget extends StatelessWidget {
  final PriceType? selectedPriceType;
  final void Function(PriceType priceType) onTap;
  const PricesTypesWidget({
    super.key,
    required this.selectedPriceType,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TitleWidget(title: "Tipo de preço".hardcoded),
        RadioGroup<PriceType>(
          groupValue: selectedPriceType,
          onChanged: (value) {
            onTap(value!);
          },
          child: Row(
            children: [
              _PriceTypeItem(priceType: PriceType.retail, onTap: onTap),
              _PriceTypeItem(priceType: PriceType.whole, onTap: onTap),
            ],
          ),
        ),
      ],
    );
  }
}

class _PriceTypeItem extends StatelessWidget {
  final void Function(PriceType newType) onTap;
  final PriceType priceType;
  const _PriceTypeItem({required this.priceType, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: priceType.name.length,
      child: InkWell(
        onTap: () {
          onTap(priceType);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(child: Text(priceType.name)),
            Radio(value: priceType),
          ],
        ),
      ),
    );
  }
}
