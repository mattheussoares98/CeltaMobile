import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/adjust_sale_price/domain/entities/entities.dart';
import 'package:celta_inventario/features/adjust_sale_price/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/adjust_sale_price/presentation/pages/components/components.dart';

class PricesTypesWidget extends ConsumerWidget {
  final String plu;
  const PricesTypesWidget({super.key, required this.plu});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const items = [PriceType.sale, PriceType.offer];
    final width = MediaQuery.sizeOf(context).width;
    bool showVertical = width < 200;
    final theme = Theme.of(context);

    final selectedPriceType = ref.watch(
      uIStateControllerProvider(plu).select((s) => s.value?.selectedPriceType),
    );

    void unTap(PriceType? priceType) {
      ref
          .read(uIStateControllerProvider(plu).notifier)
          .updateValues(selectedPriceType: priceType);
    }

    return Column(
      children: [
        TitleWidget(title: "Tipo de preço".hardcoded),
        gapH8,
        if (theme.platform == TargetPlatform.iOS)
          DefaultSegmentedButtons<PriceType>(
            items: items,
            selectedValue: selectedPriceType?.value,
            onChanged: unTap,
          )
        else
          RadioGroup<PriceType>(
            key: Key(showVertical ? "vertical" : "horizontal"),
            groupValue: selectedPriceType?.value,
            onChanged: unTap,
            child: showVertical
                ? Column(
                    children: items
                        .map(
                          (e) => _PriceTypeItem(
                            key: ValueKey('price_type_${e.name}'),
                            priceType: e,
                            onTap: unTap,
                          ),
                        )
                        .toList(),
                  )
                : Row(
                    children: items
                        .map(
                          (e) => Flexible(
                            flex: e.name.length,
                            child: _PriceTypeItem(
                              key: ValueKey('price_type_${e.name}'),
                              priceType: e,
                              onTap: unTap,
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

class _PriceTypeItem extends StatelessWidget {
  final void Function(PriceType newType) onTap;
  final PriceType priceType;
  const _PriceTypeItem({
    super.key,
    required this.priceType,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
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
