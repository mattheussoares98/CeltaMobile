import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../core/presentation/controllers/stock/stock.dart';
import '../../../controllers/controllers.dart';

class DestinyStocksDropdown extends ConsumerWidget {
  final int enterpriseCode;
  const DestinyStocksDropdown({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stocksAsync = ref.watch(
      stockTypeStateControllerProvider(enterpriseCode),
    );

    final selectedOriginStock = ref.watch(
      selectedProductUIStateControllerProvider(
        enterpriseCode,
      ).select((s) => s.selectedOriginStock),
    );
    final selectedDestinyStock = ref.watch(
      selectedProductUIStateControllerProvider(
        enterpriseCode,
      ).select((s) => s.selectedDestinyStock),
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
                  selectedProductUIStateControllerProvider(
                    enterpriseCode,
                  ).notifier,
                )
                .updateValues(destinyStock: value);
          },
          validator: (value) {
            if (value == null) {
              return 'Estoque obrigatório'.hardcoded;
            } else if (value == selectedOriginStock) {
              return 'Estoque igual ao de origem'.hardcoded;
            }
            return null;
          },
          items: stocks.map((e) {
            return DropdownMenuItem(
              value: e,
              child: Center(child: Text(e.Nome_TipoEstoque)),
            );
          }).toList(),
          value: selectedDestinyStock,
          hint: 'Estoque de destino'.hardcoded,
        );
      },
    );
  }
}
