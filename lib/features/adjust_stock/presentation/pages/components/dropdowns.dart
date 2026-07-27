import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/adjust_stock/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/adjust_stock/presentation/pages/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Dropdowns extends ConsumerWidget {
  final int enterpriseCode;
  const Dropdowns({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDesktop = MediaQuery.sizeOf(context).width > Breakpoint.desktop;
    final dropDowns = [
      Padding(
        padding: EdgeInsets.only(
          bottom: isDesktop ? 0 : Sizes.p8,
          right: isDesktop ? Sizes.p8 : 0,
        ),
        child: JustificationsDropdown(enterpriseCode: enterpriseCode),
      ),
      StocksDropdown(enterpriseCode: enterpriseCode),
    ];

    if (isDesktop) {
      return Row(children: dropDowns.map((e) => Expanded(child: e)).toList());
    }
    final selectedJustification = ref.watch(
      selectedUIStateControllerProvider(
        enterpriseCode,
      ).select((s) => s.selectedJustification),
    );
    final selectedStockType = ref.watch(
      selectedUIStateControllerProvider(
        enterpriseCode,
      ).select((s) => s.selectedStockType),
    );

    return ExpansionTile(
      collapsedIconColor: context.theme.colorScheme.onSurface,
      textColor: context.theme.colorScheme.onSurface,
      initiallyExpanded:
          selectedJustification == null || selectedStockType == null,
      title: Column(
        crossAxisAlignment: .start,
        children: [
          BaseText(
            selectedJustification?.Descricao_JustMov == null
                ? 'Sem justificativa'.hardcoded
                : '${selectedJustification?.Descricao_JustMov}'.hardcoded,
            color: selectedJustification?.Descricao_JustMov == null
                ? Colors.red
                : context.theme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
          BaseText(
            selectedStockType?.Nome_TipoEstoque == null
                ? 'Sem origem'.hardcoded
                : '${selectedStockType?.Nome_TipoEstoque}'.hardcoded,
            color: selectedStockType?.Nome_TipoEstoque == null
                ? Colors.red
                : context.theme.primaryColorDark,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
      children: dropDowns,
    );
  }
}
