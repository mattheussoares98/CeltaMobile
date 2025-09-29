import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/stock/stock.dart';

class StocksDropdown extends ConsumerWidget {
  final AsyncValue<List<StockTypeEntity>> asyncValue;
  final int enterpriseCode;
  final TransferJustificationEntity? selectedJustification;
  final StockTypeEntity? selectedStockType;
  final void Function(StockTypeEntity? value) onChanged;
  const StocksDropdown({
    super.key,
    required this.asyncValue,
    required this.enterpriseCode,
    required this.selectedJustification,
    required this.selectedStockType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueWidget(
      value: asyncValue,
      tryAgain: () {
        ref.invalidate(stockTypeStateControllerProvider(enterpriseCode));
      },
      data: (stocks) {
        return DefaultSimpleDropDown<StockTypeEntity?>(
          isLoading: asyncValue.isLoading,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: selectedJustification?.CodigoInterno_TipoEstoque != null
              ? null
              : onChanged,
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
    );
  }
}
