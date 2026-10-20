import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

class DiscountAnalysisTable extends StatelessWidget {
  final ProviderBase<AsyncValue<dynamic>> refreshProvider;
  final List<BSFSaleRequestDiscountItemEntity> items;
  const DiscountAnalysisTable({
    super.key,
    required this.refreshProvider,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return ScrollableTable<BSFSaleRequestDiscountItemEntity>(
      items: items,
      fixFirstColumn: true,
      rowHeight: 45,
      refreshProvider: refreshProvider,
      columns: [
        ScrollableTableColumnSpec<BSFSaleRequestDiscountItemEntity>(
          headerTitle: context.l10n.product,
          minWidth: 170.0,
          cellBuilder: (item) => BaseRichText(
            texts: [
              BaseText.title(
                item.product.packingPriceLookUp,
                color: context.theme.primaryColor,
              ),
              BaseText.title(
                ' (${item.product.packingName})',
                color: Colors.blue,
              ),
              BaseText.title(' ${item.product.name}'),
            ],
            maxLines: 2,
          ),
          sortValueMapper: (item) => item.product.name,
        ),
        ScrollableTableColumnSpec<BSFSaleRequestDiscountItemEntity>(
          headerTitle: context.l10n.quantityShort,
          minWidth: 50.0,
          cellBuilder: (item) =>
              BaseText(item.quantity.toString().toBrazilianNumber(3, true)),
          sortValueMapper: (item) => item.quantity,
          footerCellBuilder: (items) => BaseText(
            items
                .fold<double>(0, (sum, item) => sum + item.quantity)
                .toString()
                .toBrazilianNumber(2, true),

            fontWeight: FontWeight.bold,
          ),
        ),
        ScrollableTableColumnSpec<BSFSaleRequestDiscountItemEntity>(
          headerTitle: context.l10n.gross,
          isMoney: true,
          minWidth: 80.0,
          cellBuilder: (item) =>
              BaseText(item.bruteValue.toString().toBrazilianNumber()),
          sortValueMapper: (item) => item.bruteValue,
          footerCellBuilder: (items) => BaseText(
            items
                .fold<double>(0, (sum, item) => sum + item.bruteValue)
                .toString()
                .toBrazilianNumber(),
            fontWeight: FontWeight.bold,
          ),
        ),
        ScrollableTableColumnSpec<BSFSaleRequestDiscountItemEntity>(
          headerTitle: context.l10n.disc,
          isMoney: true,
          minWidth: 80.0,
          cellBuilder: (item) =>
              BaseText(item.discountValue.toString().toBrazilianNumber()),
          sortValueMapper: (item) => item.discountValue,
          footerCellBuilder: (items) => BaseText(
            items
                .fold<double>(0, (sum, item) => sum + item.discountValue)
                .toString()
                .toBrazilianNumber(),
            fontWeight: FontWeight.bold,
          ),
        ),
        ScrollableTableColumnSpec<BSFSaleRequestDiscountItemEntity>(
          headerTitle: context.l10n.disc,
          isPercentage: true,
          minWidth: 60.0,
          cellBuilder: (item) => BaseText(
            item.discountPercentage.toString().toBrazilianNumber(2, true),
          ),
          sortValueMapper: (item) => item.discountPercentage,
        ),
        ScrollableTableColumnSpec<BSFSaleRequestDiscountItemEntity>(
          headerTitle: context.l10n.net2,
          isMoney: true,
          minWidth: 80.0,
          cellBuilder: (item) =>
              BaseText(item.liquidValue.toString().toBrazilianNumber()),
          sortValueMapper: (item) => item.liquidValue,
          footerCellBuilder: (items) => BaseText(
            items
                .fold<double>(0, (sum, item) => sum + item.liquidValue)
                .toString()
                .toBrazilianNumber(),
            fontWeight: FontWeight.bold,
          ),
        ),
        ScrollableTableColumnSpec<BSFSaleRequestDiscountItemEntity>(
          headerTitle: context.l10n.max,
          isPercentage: true,
          minWidth: 55.0,
          cellBuilder: (item) => BaseText(
            item.discountConcessionLimitPercentage.toString().toBrazilianNumber(
              2,
              true,
            ),
          ),
          sortValueMapper: (item) => item.discountConcessionLimitPercentage,
        ),
        ScrollableTableColumnSpec<BSFSaleRequestDiscountItemEntity>(
          headerTitle: context.l10n.difference,
          isPercentage: true,
          minWidth: 80.0,
          cellBuilder: (item) => BaseText(
            item.totalDifference.toString().toBrazilianNumber(2, true),
            color: item.hasPositiveDifference ? Colors.red : Colors.green,
          ),
          footerCellBuilder: (items) {
            final avg =
                (items.fold<double>(0, (p, e) => p + e.totalDifference) /
                items.length);
            return BaseText(
              avg.toString().toBrazilianNumber(2, true),
              fontWeight: FontWeight.bold,
              color: avg > 0 ? Colors.red : Colors.green,
            );
          },
          sortValueMapper: (item) => item.totalDifference,
        ),
      ],
    );
  }
}
