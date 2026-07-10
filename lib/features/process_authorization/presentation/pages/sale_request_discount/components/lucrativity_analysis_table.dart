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
          minWidth: 80.0,
          cellBuilder: (item) =>
              BaseText(item.replacementCost.toString().toBrazilianNumber(2)),
          sortValueMapper: (item) => item.replacementCost,
          footerCellBuilder: (items) => BaseText(
            items
                .fold<double>(0, (sum, item) => sum + item.replacementCost)
                .toString()
                .toBrazilianNumber(2),
            fontWeight: FontWeight.bold,
          ),
        ),
        ScrollableTableColumnSpec<BSFSaleRequestLucrativityItemEntity>(
          headerTitle: 'Cust líq'.hardcoded,
          isMoney: true,
          minWidth: 80.0,
          cellBuilder: (item) =>
              BaseText(item.liquidCost.toString().toBrazilianNumber(2)),
          sortValueMapper: (item) => item.liquidCost,
          footerCellBuilder: (items) => BaseText(
            items
                .fold<double>(0, (sum, item) => sum + item.liquidCost)
                .toString()
                .toBrazilianNumber(2),
            fontWeight: FontWeight.bold,
          ),
        ),
        ScrollableTableColumnSpec<BSFSaleRequestLucrativityItemEntity>(
          headerTitle: 'Desp op'.hardcoded,
          isPercentage: true,
          minWidth: 80,
          cellBuilder: (item) => BaseText(
            item.operationalExpense.toString().toBrazilianNumber(2, true),
          ),
          sortValueMapper: (item) => item.operationalExpense,
        ),
        ScrollableTableColumnSpec<BSFSaleRequestLucrativityItemEntity>(
          headerTitle: 'Imposto'.hardcoded,
          isMoney: true,
          minWidth: 80.0,
          cellBuilder: (item) =>
              BaseText(item.taxValue.toString().toBrazilianNumber(2)),
          sortValueMapper: (item) => item.taxValue,
          footerCellBuilder: (items) => BaseText(
            items
                .fold<double>(0, (sum, item) => sum + item.taxValue)
                .toString()
                .toBrazilianNumber(2),
            fontWeight: FontWeight.bold,
          ),
        ),
        ScrollableTableColumnSpec<BSFSaleRequestLucrativityItemEntity>(
          headerTitle: 'Faturamento'.hardcoded,
          isMoney: true,
          minWidth: 80,
          cellBuilder: (item) =>
              BaseText(item.billingValue.toString().toBrazilianNumber(2)),
          sortValueMapper: (item) => item.billingValue,
        ),
        ScrollableTableColumnSpec<BSFSaleRequestLucrativityItemEntity>(
          headerTitle: 'Lucro'.hardcoded,
          isMoney: true,
          minWidth: 80.0,
          cellBuilder: (item) =>
              BaseText(item.profitValue.toString().toBrazilianNumber(2)),
          sortValueMapper: (item) => item.profitValue,
        ),
        ScrollableTableColumnSpec<BSFSaleRequestLucrativityItemEntity>(
          headerTitle: 'Margem'.hardcoded,
          isPercentage: true,
          minWidth: 80.0,
          cellBuilder: (item) =>
              BaseText(item.praticedMargin.toString().toBrazilianNumber(2)),
          sortValueMapper: (item) => item.praticedMargin,
        ),
        ScrollableTableColumnSpec<BSFSaleRequestLucrativityItemEntity>(
          headerTitle: 'Mín'.hardcoded,
          isMoney: true,
          minWidth: 80.0,
          cellBuilder: (item) => BaseText(
            item.unitMinimumSalePrice.toString().toBrazilianNumber(2),
          ),
          sortValueMapper: (item) => item.praticedMargin,
        ),
        ScrollableTableColumnSpec<BSFSaleRequestLucrativityItemEntity>(
          headerTitle: 'Venda'.hardcoded,
          isMoney: true,
          minWidth: 80.0,
          cellBuilder: (item) =>
              BaseText(item.unitAppliedPrice.toString().toBrazilianNumber(2)),
          sortValueMapper: (item) => item.unitAppliedPrice,
        ),
        ScrollableTableColumnSpec<BSFSaleRequestLucrativityItemEntity>(
          headerTitle: 'Dif unit'.hardcoded,
          isMoney: true,
          minWidth: 80.0,
          cellBuilder: (item) =>
              BaseText(item.unitDifference.toString().toBrazilianNumber(2)),
          sortValueMapper: (item) => item.unitDifference,
        ),
        ScrollableTableColumnSpec<BSFSaleRequestLucrativityItemEntity>(
          headerTitle: 'Total dif'.hardcoded,
          isMoney: true,
          minWidth: 80.0,
          cellBuilder: (item) => BaseText(
            item.totalDifference.toString().toBrazilianNumber(2),
            color: item.totalDifference < 0 ? Colors.red : Colors.green,
          ),
          sortValueMapper: (item) => item.totalDifference,
        ),
      ],
    );
  }
}
