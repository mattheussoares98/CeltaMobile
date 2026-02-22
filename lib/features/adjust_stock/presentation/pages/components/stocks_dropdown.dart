import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/stock/stock.dart';
import '../../controllers/controllers.dart';

class StocksDropdown extends ConsumerWidget {
  final int enterpriseCode;
  const StocksDropdown({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stocksAsync = ref.watch(
      stockTypeStateControllerProvider(enterpriseCode),
    );
    final selectedStockType = ref.watch(
      selectedUIStateControllerProvider(
        enterpriseCode,
      ).select((s) => s.selectedStockType),
    );
    final selectedJustificationInternalCode = ref.watch(
      selectedUIStateControllerProvider(
        enterpriseCode,
      ).select((s) => s.selectedJustification?.CodigoInterno_TipoEstoque),
    );

    return RepaintBoundary(
      child: AsyncValueWidget(
        value: stocksAsync,
        tryAgain: () {
          ref.invalidate(stockTypeStateControllerProvider(enterpriseCode));
        },
        data: (stocks) {
          return DefaultSimpleDropDown<StockTypeEntity?>(
            isLoading: stocksAsync.isLoading,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: selectedJustificationInternalCode != null
                ? null
                : (value) {
                    ref
                        .read(
                          selectedUIStateControllerProvider(
                            enterpriseCode,
                          ).notifier,
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
            value: selectedStockType,
            hint: 'Estoque de destino'.hardcoded,
          );
        },
      ),
    );
  }
}
