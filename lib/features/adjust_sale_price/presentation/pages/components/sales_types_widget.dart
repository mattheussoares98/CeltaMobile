import 'package:celta_intelligence/features/enterprises/presentation/controllers/selected_enterprise_state_controller.dart';
import 'package:celta_intelligence/localization/string_hardcoded.dart';
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
    final selectedEnterprise = ref.watch(
      selectedEnterpriseStateControllerProvider,
    );
    final items = [
      if (selectedEnterprise?.UseRetailSale == true) SaleType.retail,
      if (selectedEnterprise?.UseWholeSale == true) SaleType.whole,
      if (selectedEnterprise?.UseEcommerceSale == true) SaleType.ecommerce,
    ];

    final mediaQuery = MediaQuery.of(context);
    bool showInVertical = mediaQuery.size.width < 300;
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
            key: ValueKey(showInVertical ? "vertical" : "horizontal"),
            groupValue: selectedSaleType,
            onChanged: updateValue,
            child: showInVertical
                ? Column(
                    children: [
                      ...items.map(
                        (e) => _SaleTypeItem(saleType: e, onTap: updateValue),
                      ),
                    ],
                  )
                : Row(
                    children: items
                        .map(
                          (e) => Flexible(
                            flex: e.name.length,
                            child: _SaleTypeItem(
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
