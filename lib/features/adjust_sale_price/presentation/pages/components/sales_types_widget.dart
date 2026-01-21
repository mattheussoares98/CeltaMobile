import 'package:celta_inventario/features/enterprises/presentation/controllers/selected_enterprise_state_controller.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../domain/entities/entities.dart';
import '../../controllers/controllers.dart';
import 'components.dart';

class SalesTypeWidget extends ConsumerWidget {
  final String plu;
  const SalesTypeWidget({super.key, required this.plu});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (useRetail, useWhole, useEcommerce) = ref.watch(
      selectedEnterpriseStateControllerProvider.select(
        (e) => (
          e?.UseRetailSale == true,
          e?.UseWholeSale == true,
          e?.UseEcommerceSale == true,
        ),
      ),
    );

    final items = [
      if (useRetail) SaleType.retail,
      if (useWhole) SaleType.whole,
      if (useEcommerce) SaleType.ecommerce,
    ];

    final screenWidth = MediaQuery.sizeOf(context).width;
    final bool showInVertical = screenWidth < 300;
    final theme = Theme.of(context);

    final selectedSaleType = ref.watch(
      uIStateControllerProvider(plu).select((s) => s.value?.selectedSaleType),
    );

    void updateValue(SaleType? saleType) {
      ref
          .read(uIStateControllerProvider(plu).notifier)
          .updateValues(selectedSaleType: saleType);
    }

    return Column(
      children: [
        TitleWidget(title: "Tipo de venda".hardcoded),
        gapH8,
        if (theme.platform == TargetPlatform.iOS)
          DefaultSegmentedButtons<SaleType>(
            items: items,
            selectedValue: selectedSaleType?.value,
            onChanged: updateValue,
          )
        else
          RadioGroup<SaleType>(
            key: ValueKey('sales_type_layout_${showInVertical ? "v" : "h"}'),
            groupValue: selectedSaleType,
            onChanged: updateValue,
            child: showInVertical
                ? Column(
                    children: [
                      ...items.map(
                        (e) => _SaleTypeItem(
                          key: ValueKey('sale_item_${e.name}'),
                          saleType: e,
                          onTap: updateValue,
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: items
                        .map(
                          (e) => Flexible(
                            flex: e.name.length,
                            child: _SaleTypeItem(
                              key: ValueKey('sale_item_${e.name}'),
                              saleType: e,
                              onTap: updateValue,
                            ),
                          ),
                        )
                        .toList(),
                  ),
          ),
      ],
    );
  }
}

class _SaleTypeItem extends StatelessWidget {
  final void Function(SaleType newType) onTap;
  final SaleType saleType;
  const _SaleTypeItem({super.key, required this.saleType, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: InkWell(
        onTap: () => onTap(saleType),
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
