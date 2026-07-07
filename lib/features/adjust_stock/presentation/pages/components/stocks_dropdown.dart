import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/stock/stock.dart';
import 'package:celta_inventario/features/adjust_stock/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
          return BaseDropDown<StockTypeEntity?>(
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
                child: BaseText(e.Nome_TipoEstoque),
              );
            }).toList(),
            selectedItem: selectedStockType,
            label: 'Estoque de destino'.hardcoded,
            isSimple: true,
          );
        },
      ),
    );
  }
}
