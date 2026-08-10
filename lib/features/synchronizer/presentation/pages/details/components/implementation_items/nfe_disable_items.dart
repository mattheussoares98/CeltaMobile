import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';

class NfeDisableItems extends StatelessWidget {
  const NfeDisableItems({super.key, required this.items});
  final List<EcNFeDisableSynchronizerErrorDetailEntity> items;

  @override
  Widget build(BuildContext context) {
    return ScrollableTable<EcNFeDisableSynchronizerErrorDetailEntity>(
      items: items,
      columns: [
        ScrollableTableColumnSpec(
          headerTitle: 'Empresa'.hardcoded,
          minWidth: 70,
          cellBuilder: (item) =>
              BaseText(item.enterprisePersonalizedCode.toString()),
        ),
        ScrollableTableColumnSpec(
          headerTitle: 'Emissão'.hardcoded,
          minWidth: 150,
          cellBuilder: (item) =>
              BaseText(item.issuanceDate.formatDate(.ddMMyyyyHHmm)),
        ),
        ScrollableTableColumnSpec(
          headerTitle: 'NF'.hardcoded,
          minWidth: 60,
          cellBuilder: (item) => BaseText(item.number.toString()),
        ),
        ScrollableTableColumnSpec(
          headerTitle: 'Série'.hardcoded,
          minWidth: 60,
          cellBuilder: (item) => BaseText(item.series),
        ),
      ],
    );
  }
}
