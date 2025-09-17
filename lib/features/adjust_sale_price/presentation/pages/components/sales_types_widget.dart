import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

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
    return Column(
      children: [
        TitleWidget(title: "Tipo de venda".hardcoded),
        RadioGroup<SaleType>(
          groupValue: selectedSaleType,
          onChanged: (value) {
            onTap(value!);
          },
          child: Row(
            children: [
              if (selectedEnterprise?.UseRetailSale == true)
                _SaleTypeItem(saleType: SaleType.retail, onTap: onTap),
              if (selectedEnterprise?.UseWholeSale == true)
                _SaleTypeItem(saleType: SaleType.whole, onTap: onTap),
              if (selectedEnterprise?.UseEcommerceSale == true)
                _SaleTypeItem(saleType: SaleType.ecommerce, onTap: onTap),
            ],
          ),
        ),
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
    return Flexible(
      flex: saleType.name.length,
      child: InkWell(
        onTap: () {
          onTap(saleType);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(child: Text(saleType.name)),
            Radio(value: saleType),
          ],
        ),
      ),
    );
  }
}
