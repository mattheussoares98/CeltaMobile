import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/transfer_between_stocks/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/transfer_between_stocks/presentation/pages/products/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DropDowns extends ConsumerWidget {
  const DropDowns({super.key, required this.enterpriseCode});
  final int enterpriseCode;

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
      Padding(
        padding: EdgeInsets.only(
          bottom: isDesktop ? 0 : Sizes.p8,
          right: isDesktop ? Sizes.p8 : 0,
        ),
        child: OriginStocksDropdown(enterpriseCode: enterpriseCode),
      ),
      Padding(
        padding: EdgeInsets.only(right: isDesktop ? Sizes.p8 : 0),
        child: DestinyStocksDropdown(enterpriseCode: enterpriseCode),
      ),
    ];

    if (isDesktop) {
      return Row(children: dropDowns.map((e) => Expanded(child: e)).toList());
    }

    final justification = ref.watch(
      selectedProductUIStateControllerProvider(
        enterpriseCode,
      ).select((s) => s.selectedJustification),
    );
    final selectedOritinStock = ref.watch(
      selectedProductUIStateControllerProvider(
        enterpriseCode,
      ).select((x) => x.selectedOriginStock),
    );
    final selectedDestinyStock = ref.watch(
      selectedProductUIStateControllerProvider(
        enterpriseCode,
      ).select((s) => s.selectedDestinyStock),
    );

    return ExpansionTile(
      initiallyExpanded:
          justification == null ||
          selectedOritinStock == null ||
          selectedDestinyStock == null,
      tilePadding: const EdgeInsets.symmetric(horizontal: Sizes.p4),
      title: Column(
        crossAxisAlignment: .start,
        children: [
          BaseText(
            justification?.Descricao_JustMov == null
                ? 'Sem justificativa'.hardcoded
                : '${justification?.Descricao_JustMov}'.hardcoded,
            color: justification?.Descricao_JustMov == null
                ? Colors.red
                : context.theme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
          BaseText(
            selectedOritinStock?.Nome_TipoEstoque == null
                ? 'Sem origem'.hardcoded
                : 'De "${selectedOritinStock?.Nome_TipoEstoque}"'.hardcoded,
            color: selectedOritinStock?.Nome_TipoEstoque == null
                ? Colors.red
                : context.theme.primaryColorDark,
            fontWeight: FontWeight.bold,
          ),
          BaseText(
            selectedDestinyStock?.Nome_TipoEstoque == null
                ? 'Sem destino'.hardcoded
                : 'Para "${selectedDestinyStock?.Nome_TipoEstoque}"'.hardcoded,
            color: selectedDestinyStock?.Nome_TipoEstoque == null
                ? Colors.red
                : context.theme.colorScheme.secondary,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
      children: dropDowns,
    );
  }
}
