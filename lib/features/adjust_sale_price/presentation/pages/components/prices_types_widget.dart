import 'package:celta_inventario/features/adjust_sale_price/presentation/localization/localization.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/adjust_sale_price/domain/entities/entities.dart';
import 'package:celta_inventario/features/adjust_sale_price/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/adjust_sale_price/presentation/pages/components/components.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PricesTypesWidget extends ConsumerWidget {
  final String plu;
  const PricesTypesWidget({super.key, required this.plu});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const items = [PriceType.sale, PriceType.offer];
    final width = MediaQuery.sizeOf(context).width;
    bool showVertical = width < 200;

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
        TitleWidget(title: context.l10n.priceTypeLabel),
        gapH8,
        if (PlatformUtil.isCupertino)
          BaseSegmentedButtons<PriceType>(
            items: items,
            selectedValue: selectedPriceType,
            itemLabelBuilder: (item) =>
                context.l10n.adjustmentPriceTypeName(item),
            onChanged: unTap,
          )
        else
          RadioGroup<PriceType>(
            key: Key(showVertical ? "vertical" : "horizontal"),
            groupValue: selectedPriceType,
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
                            flex: context.l10n
                                .adjustmentPriceTypeName(e)
                                .length,
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
            Flexible(
              child: BaseText(context.l10n.adjustmentPriceTypeName(priceType)),
            ),
            Radio(value: priceType),
          ],
        ),
      ),
    );
  }
}
