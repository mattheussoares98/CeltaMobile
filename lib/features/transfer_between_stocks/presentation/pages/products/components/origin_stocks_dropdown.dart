import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/stock/stock.dart';
import 'package:celta_inventario/features/transfer_between_stocks/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OriginStocksDropdown extends ConsumerWidget {
  final int enterpriseCode;
  const OriginStocksDropdown({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedJustification = ref.watch(
      selectedProductUIStateControllerProvider(
        enterpriseCode,
      ).select((x) => x.selectedJustification),
    );
    final selectedOritinStock = ref.watch(
      selectedProductUIStateControllerProvider(
        enterpriseCode,
      ).select((x) => x.selectedOriginStock),
    );

    return AsyncValueWidget(
      value: ref.watch(stockTypeStateControllerProvider(enterpriseCode)),
      tryAgain: () {
        ref.invalidate(stockTypeStateControllerProvider(enterpriseCode));
      },
      data: (stocks) {
        return BaseDropDown<StockTypeEntity?>(
          onChanged: selectedJustification?.CodigoInterno_TipoEstoque != null
              ? null
              : (value) {
                  ref
                      .read(
                        selectedProductUIStateControllerProvider(
                          enterpriseCode,
                        ).notifier,
                      )
                      .updateValues(originStock: value);
                },
          validator: (value) {
            if (value == null) {
              return 'Estoque obrigatório'.hardcoded;
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
          selectedItem: selectedOritinStock,
          label: 'Estoque de origem'.hardcoded,
          isSimple: true,
        );
      },
    );
  }
}
