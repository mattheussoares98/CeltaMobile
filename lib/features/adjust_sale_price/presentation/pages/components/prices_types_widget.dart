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
    final items = [
      _PriceTypeItem(priceType: PriceType.sale, onTap: onTap),
      _PriceTypeItem(priceType: PriceType.offer, onTap: onTap),
    ];
    final mediaQuery = MediaQuery.of(context);
    bool showVertical = mediaQuery.size.width < 200;
    return Column(
      children: [
        TitleWidget(title: "Tipo de preço".hardcoded),
        RadioGroup<PriceType>(
          key: Key(showVertical ? "vertical" : "horizontal"),
          groupValue: selectedPriceType,
          onChanged: (value) {
            onTap(value!);
          },
          child: showVertical
              ? Column(children: items)
              : Row(
                  children: items
                      .map(
                        (e) =>
                            Flexible(flex: e.priceType.name.length, child: e),
                      )
                      .toList(),
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
    return InkWell(
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
    );
  }
}
