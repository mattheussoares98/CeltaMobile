import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';

class CustomersWithErrorsItems extends StatelessWidget {
  const CustomersWithErrorsItems({super.key, required this.items});
  final List<BSFCustomerWithErrorSynchronizerErrorDetailEntity> items;

  @override
  Widget build(BuildContext context) {
    return ScrollableTable<BSFCustomerWithErrorSynchronizerErrorDetailEntity>(
      items: items,
      rowHeight: 60,
      columns: [
        ScrollableTableColumnSpec(
          headerTitle: 'Empresa'.hardcoded,
          minWidth: 70,
          cellBuilder: (item) =>
              BaseText(item.enterprisePersonalizedCode.toString()),
        ),
        ScrollableTableColumnSpec(
          headerTitle: 'Nome cliente'.hardcoded,
          minWidth: 150,
          cellBuilder: (item) => BaseText(item.customerName),
        ),
        ScrollableTableColumnSpec(
          headerTitle: 'Data erro'.hardcoded,
          minWidth: 120,
          cellBuilder: (item) =>
              BaseText(item.creationDate.formatDate(.ddMMyyyyHHmm)),
        ),
        ScrollableTableColumnSpec(
          headerTitle: 'Data cadastro'.hardcoded,
          minWidth: 120,
          cellBuilder: (item) =>
              BaseText(item.cadasterDate.formatDate(.ddMMyyyyHHmm)),
        ),
        ScrollableTableColumnSpec(
          headerTitle: 'Cód cliente'.hardcoded,
          minWidth: 200,
          cellBuilder: (item) => BaseText(item.customerCode),
        ),
      ],
    );
  }
}
