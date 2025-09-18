import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../domain/entities/entities.dart';
import 'components.dart';

class SalesTypeWidget extends StatelessWidget {
  final SaleType? selectedSaleType;
  final void Function(SaleType saleType) onTap;
  final EnterpriseEntity? selectedEnterprise;
  const SalesTypeWidget({
    super.key,
    required this.selectedSaleType,
    required this.selectedEnterprise,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      if (selectedEnterprise?.UseRetailSale == true) SaleType.retail,
      if (selectedEnterprise?.UseWholeSale == true) SaleType.whole,
      if (selectedEnterprise?.UseEcommerceSale == true) SaleType.ecommerce,
    ];

    final mediaQuery = MediaQuery.of(context);
    bool showInVertical = mediaQuery.size.width < 300;
    final theme = Theme.of(context);

    return Column(
      children: [
        TitleWidget(title: "Tipo de venda".hardcoded),
        gapH8,
        if (theme.platform == TargetPlatform.iOS)
          DefaultSegmentedButtons<SaleType>(
            items: items,
            selectedValue: selectedSaleType?.value,
            onChanged: onTap,
          )
        else
          RadioGroup<SaleType>(
            key: ValueKey(showInVertical ? "vertical" : "horizontal"),
            groupValue: selectedSaleType,
            onChanged: (value) {
              onTap(value!);
            },
            child: showInVertical
                ? Column(
                    children: [
                      ...items.map(
                        (e) => _SaleTypeItem(saleType: e, onTap: onTap),
                      ),
                    ],
                  )
                : Row(
                    children: items
                        .map(
                          (e) => Flexible(
                            flex: e.name.length,
                            child: _SaleTypeItem(saleType: e, onTap: onTap),
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

class _SaleTypeItem extends StatelessWidget {
  final void Function(SaleType newType) onTap;
  final SaleType saleType;
  const _SaleTypeItem({required this.saleType, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(saleType),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(child: Text(saleType.name)),
          Radio(value: saleType),
        ],
      ),
    );
  }
}
