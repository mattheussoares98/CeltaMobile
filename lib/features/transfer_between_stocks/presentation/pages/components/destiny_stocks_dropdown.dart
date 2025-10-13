import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/stock/stock.dart';

class DestinyStocksDropdown extends ConsumerWidget {
  final AsyncValue<List<StockTypeEntity>> asyncValue;
  final int enterpriseCode;
  final StockTypeEntity? selectedOriginStock;
  final StockTypeEntity? selectedDestinyStock;
  final void Function(StockTypeEntity? value) onChanged;
  final EnterpriseEntity? selectedEnterprise;
  const DestinyStocksDropdown({
    super.key,
    required this.asyncValue,
    required this.enterpriseCode,
    required this.selectedOriginStock,
    required this.selectedDestinyStock,
    required this.onChanged,
    required this.selectedEnterprise,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueWidget(
      value: asyncValue,
      tryAgain: () {
        ref.invalidate(
          stockTypeStateControllerProvider(
            enterpriseCode,
            selectedEnterprise?.name ?? '',
          ),
        );
      },
      data: (stocks) {
        return DefaultSimpleDropDown<StockTypeEntity?>(
          isLoading: asyncValue.isLoading,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: onChanged,
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
