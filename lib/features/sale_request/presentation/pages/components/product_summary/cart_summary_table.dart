import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/sale_request/presentation/pages/components/product_summary/discount_presentation_extensions.dart';
import 'package:celta_inventario/features/sale_request/presentation/pages/components/product_summary/summary_tooltip.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartSummaryTable extends ConsumerWidget {
  final BSFProductItemEntity item;
  const CartSummaryTable({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Performance optimization: select only the requestType to prevent unnecessary rebuilds.
    final requestType = ref.watch(
      insertUpdateStateControllerProvider.select((s) => s.value?.requestType),
    );
    final practicedPrice = item.getPracticedPriceType(requestType);

    return SummaryTable(
      items: [
        SummaryTableItem(
          title: 'Preço'.hardcoded,
          value: item.value,
          decimalHouses: 2,
          isPrice: true,
          trailing: SummaryTooltip(
            message: practicedPrice.description,
            text: practicedPrice.abbreviation,
          ),
        ),
        if (item.totalDeliveryTax > 0)
          SummaryTableItem(
            title: 'Frete'.hardcoded,
            value: item.totalDeliveryTax,
            isPrice: true,
            color: context.theme.colorScheme.secondary,
          ),
        if (item.totalDiscountValue > 0)
          SummaryTableItem(
            title: 'Desconto'.hardcoded,
            value: item.totalDiscountValue,
            isPrice: true,
            color: Colors.red,
            trailing: SummaryTooltip(
              message: item.discounts.formattedDescription,
              color: Colors.red,
            ),
          ),
        if (item.totalIncrement > 0)
          SummaryTableItem(
            title: 'Acréscimo'.hardcoded,
            value: item.totalIncrement,
            isPrice: true,
            color: Colors.orange,
          ),
        SummaryTableItem(
          title: 'Total'.hardcoded,
          value: item.totalLiquid,
          isPrice: true,
          color: context.theme.primaryColor,
        ),
      ],
    );
  }
}
