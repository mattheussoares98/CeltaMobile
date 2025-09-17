import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
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
    final items = [PriceType.sale, PriceType.offer];
    final mediaQuery = MediaQuery.of(context);
    bool showVertical = mediaQuery.size.width < 200;
    final theme = Theme.of(context);

    return Column(
      children: [
        TitleWidget(title: "Tipo de preço".hardcoded),
        if (theme.platform == TargetPlatform.iOS)
          DefaultCupertinoCheckBox(
            items: items,
            selectedSaleType: selectedPriceType,
            onTap: onTap,
          )
        else
          RadioGroup<PriceType>(
            key: Key(showVertical ? "vertical" : "horizontal"),
            groupValue: selectedPriceType,
            onChanged: (value) {
              onTap(value!);
            },
            child: showVertical
                ? Column(
                    children: items
                        .map((e) => _PriceTypeItem(priceType: e, onTap: onTap))
                        .toList(),
                  )
                : Row(
                    children: items
                        .map(
                          (e) => Flexible(
                            flex: e.name.length,
                            child: _PriceTypeItem(priceType: e, onTap: onTap),
                          ),
                        )
                        .toList(),
                  ),
          ),
        Divider(),
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
