import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/stock/stock.dart';
import 'package:celta_inventario/features/transfer_between_stocks/presentation/controllers/controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DestinyStocksDropdown extends ConsumerWidget {
  final int enterpriseCode;
  const DestinyStocksDropdown({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDestinyStock = ref.watch(
      selectedProductUIStateControllerProvider(
        enterpriseCode,
      ).select((s) => s.selectedDestinyStock),
    );

    return AsyncValueWidget(
      value: ref.watch(stockTypeStateControllerProvider(enterpriseCode)),
      tryAgain: () {
        ref.invalidate(stockTypeStateControllerProvider(enterpriseCode));
      },
      data: (stocks) {
        return BaseDropDown<StockTypeEntity?>(
          showLabelAtTopLeft: true,
          onChanged: (value) {
            ref
                .read(
                  selectedProductUIStateControllerProvider(
                    enterpriseCode,
                  ).notifier,
                )
                .updateValues(destinyStock: value);
          },
          validator: (value) {
            final selectedOriginStock = ref.read(
              selectedProductUIStateControllerProvider(
                enterpriseCode,
              ).select((s) => s.selectedOriginStock),
            );

            if (value == null) {
              return context.l10n.stockRequired;
            } else if (value == selectedOriginStock) {
              return context.l10n.sameStockAsTheSource;
            }
            return null;
          },
          items: stocks.map((e) {
            return DropdownMenuItem(
              key: ValueKey(e.CodigoInterno_TipoEstoque),
              value: e,
              child: Center(child: Text(e.Nome_TipoEstoque)),
            );
          }).toList(),
          selectedItem: selectedDestinyStock,
          label: context.l10n.destinationStock,
          isSimple: true,
        );
      },
    );
  }
}
