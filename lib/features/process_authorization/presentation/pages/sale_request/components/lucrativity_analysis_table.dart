import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

class LucrativityAnalysisTable extends StatelessWidget {
  final ProviderBase<AsyncValue<dynamic>> refreshProvider;
  final List<BSFSaleRequestLucrativityItemEntity> items;
  const LucrativityAnalysisTable({
    super.key,
    required this.refreshProvider,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return ScrollableTable<BSFSaleRequestLucrativityItemEntity>(
      items: items,
      fixFirstColumn: true,
      rowHeight: 45,
      refreshProvider: refreshProvider,
      columns: [
        ScrollableTableColumnSpec<BSFSaleRequestLucrativityItemEntity>(
          headerTitle: 'Produto'.hardcoded,
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
        ScrollableTableColumnSpec<BSFSaleRequestLucrativityItemEntity>(
          headerTitle: 'Qtd'.hardcoded,
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
        ScrollableTableColumnSpec<BSFSaleRequestLucrativityItemEntity>(
          headerTitle: 'Reposição'.hardcoded,
          isMoney: true,
          minWidth: 95,
          cellBuilder: (item) =>
              BaseText(item.replacementCost.toString().toBrazilianNumber()),
          sortValueMapper: (item) => item.replacementCost,
          footerCellBuilder: (items) => BaseText(
            items
                .fold<double>(0, (sum, item) => sum + item.replacementCost)
                .toString()
                .toBrazilianNumber(),
            fontWeight: FontWeight.bold,
          ),
        ),
        ScrollableTableColumnSpec<BSFSaleRequestLucrativityItemEntity>(
          headerTitle: 'Cust líq'.hardcoded,
          isMoney: true,
          minWidth: 80.0,
          cellBuilder: (item) =>
              BaseText(item.liquidCost.toString().toBrazilianNumber()),
          sortValueMapper: (item) => item.liquidCost,
          footerCellBuilder: (items) => BaseText(
            items
                .fold<double>(0, (sum, item) => sum + item.liquidCost)
                .toString()
                .toBrazilianNumber(),
            fontWeight: FontWeight.bold,
          ),
        ),
        ScrollableTableColumnSpec<BSFSaleRequestLucrativityItemEntity>(
          headerTitle: 'Desp op'.hardcoded,
          isMoney: true,
          minWidth: 80,
          cellBuilder: (item) => BaseText(
            item.operationalExpense.toString().toBrazilianNumber(2, true),
          ),
          sortValueMapper: (item) => item.operationalExpense,
          footerCellBuilder: (items) => BaseText(
            items
                .fold<double>(0, (p, e) => p + e.operationalExpense)
                .toString()
                .toBrazilianNumber(),
            fontWeight: FontWeight.bold,
          ),
        ),
        ScrollableTableColumnSpec<BSFSaleRequestLucrativityItemEntity>(
          headerTitle: 'Imposto'.hardcoded,
          isMoney: true,
          minWidth: 80.0,
          cellBuilder: (item) =>
              BaseText(item.taxValue.toString().toBrazilianNumber()),
          sortValueMapper: (item) => item.taxValue,
          footerCellBuilder: (items) => BaseText(
            items
                .fold<double>(0, (sum, item) => sum + item.taxValue)
                .toString()
                .toBrazilianNumber(),
            fontWeight: FontWeight.bold,
          ),
        ),
        ScrollableTableColumnSpec<BSFSaleRequestLucrativityItemEntity>(
          headerTitle: 'Faturamento'.hardcoded,
          isMoney: true,
          minWidth: 115,
          cellBuilder: (item) =>
              BaseText(item.billingValue.toString().toBrazilianNumber()),
          sortValueMapper: (item) => item.billingValue,
          footerCellBuilder: (items) => BaseText(
            items
                .fold<double>(0, (p, e) => p + e.billingValue)
                .toString()
                .toBrazilianNumber(),
            fontWeight: FontWeight.bold,
          ),
        ),
        ScrollableTableColumnSpec<BSFSaleRequestLucrativityItemEntity>(
          headerTitle: 'Lucro'.hardcoded,
          isMoney: true,
          minWidth: 80.0,
          cellBuilder: (item) => BaseText(
            item.profitValue.toString().toBrazilianNumber(),
            color: item.profitValue > 0 ? Colors.green : Colors.red,
          ),
          sortValueMapper: (item) => item.profitValue,
          footerCellBuilder: (items) {
            final total = items.fold<double>(0, (p, e) => p + e.profitValue);
            return BaseText(
              total.toString().toBrazilianNumber(),
              fontWeight: FontWeight.bold,
              color: total > 0 ? Colors.green : Colors.red,
            );
          },
        ),
        ScrollableTableColumnSpec<BSFSaleRequestLucrativityItemEntity>(
          headerTitle: 'Margem'.hardcoded,
          isPercentage: true,
          minWidth: 80.0,
          cellBuilder: (item) => BaseText(
            item.praticedMargin.toString().toBrazilianNumber(),
            color: item.praticedMargin > 0 ? Colors.green : Colors.red,
          ),
          sortValueMapper: (item) => item.praticedMargin,
          footerCellBuilder: (items) {
            final avg =
                items.fold<double>(0, (p, e) => p + e.praticedMargin) /
                items.length;
            return BaseText(
              avg.toString().toBrazilianNumber(),
              fontWeight: FontWeight.bold,
              color: avg > 0 ? Colors.green : Colors.red,
            );
          },
        ),
        ScrollableTableColumnSpec<BSFSaleRequestLucrativityItemEntity>(
          headerTitle: 'Mín'.hardcoded,
          isMoney: true,
          minWidth: 80.0,
          cellBuilder: (item) => BaseText(
            item.unitMinimumSalePrice.toString().toBrazilianNumber(),
          ),
          sortValueMapper: (item) => item.praticedMargin,
        ),
        ScrollableTableColumnSpec<BSFSaleRequestLucrativityItemEntity>(
          headerTitle: 'Dif unit'.hardcoded,
          isMoney: true,
          minWidth: 80.0,
          cellBuilder: (item) =>
              BaseText(item.unitDifference.toString().toBrazilianNumber()),
          sortValueMapper: (item) => item.unitDifference,
        ),
        ScrollableTableColumnSpec<BSFSaleRequestLucrativityItemEntity>(
          headerTitle: 'Dif total'.hardcoded,
          isMoney: true,
          minWidth: 80.0,
          cellBuilder: (item) => BaseText(
            item.totalDifference.toString().toBrazilianNumber(),
            color: item.totalDifference < 0 ? Colors.red : Colors.green,
          ),
          sortValueMapper: (item) => item.totalDifference,
          footerCellBuilder: (items) {
            final totalDifference = items.fold<double>(
              0,
              (p, e) => p + e.totalDifference,
            );
            return BaseText(
              totalDifference.toString().toBrazilianNumber(),
              fontWeight: FontWeight.bold,
              color: totalDifference < 0 ? Colors.red : null,
            );
          },
        ),
      ],
    );
  }
}
