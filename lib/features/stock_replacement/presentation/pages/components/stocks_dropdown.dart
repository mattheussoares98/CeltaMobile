import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/stock/stock.dart';
import 'package:celta_inventario/features/stock_replacement/presentation/controllers/controllers.dart';

class StocksDropdown extends ConsumerWidget {
  final int enterpriseCode;
  const StocksDropdown({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stocksAsync = ref.watch(
      stockTypeStateControllerProvider(enterpriseCode),
    );
    final selectedUIState = ref.watch(
      selectedUIStateControllerProvider(enterpriseCode),
    );

    return AsyncValueWidget(
      value: stocksAsync,
      tryAgain: () {
        ref.invalidate(stockTypeStateControllerProvider(enterpriseCode));
      },
      data: (stocks) {
        return DefaultSimpleDropDown<StockTypeEntity?>(
          isLoading: stocksAsync.isLoading,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: (value) {
            ref
                .read(
                  selectedUIStateControllerProvider(enterpriseCode).notifier,
                )
                .updateValues(selectedStockType: value);
          },
          validator: (value) {
            if (value == null) {
              return 'Estoque obrigatório'.hardcoded;
            }
            return null;
          },
          items: stocks.map((e) {
            return DropdownMenuItem(
              value: e,
              child: Center(child: Text(e.Nome_TipoEstoque)),
            );
          }).toList(),
          value: selectedUIState.selectedStockType,
          hint: 'Estoque a ser substituído'.hardcoded,
        );
      },
    );
  }
}
