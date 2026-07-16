import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/process_authorization/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/process_authorization/presentation/pages/goods_receiving_validate_doc_xml/components/components.dart';
import 'package:celta_inventario/features/receipt/domain/entity/entity.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GRValidateDocXmlProductsTable extends ConsumerWidget {
  final bool areJudgedItems;
  final int processCode;

  const GRValidateDocXmlProductsTable({
    super.key,
    required this.areJudgedItems,
    required this.processCode,
  });

  TextSpan _buildTextSpan(BaseText baseText) {
    return TextSpan(
      text: baseText.text,
      style: TextStyle(
        color: baseText.color,
        fontSize: baseText.textType.size,
        fontWeight: baseText.fontWeight,
        decoration: baseText.decoration,
        decorationColor: baseText.decorationColor,
        fontStyle: baseText.fontStyle,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final judgmentController = markStatusJudgmentControllerProvider(
      processCode,
    );
    final provider = gRDocFiscalNoteDifferencesStateControllerProvider(
      processCode,
    );
    final uiController = gRValidateDocXmlUiControllerProvider(processCode);

    ref.observeLoading([judgmentController]);
    ref.listen(judgmentController, (previous, next) {
      next.showAlertDialogOnError(context);
      next.doOnSuccess(previous, () {
        ref
            .read(uiController.notifier)
            .clearSelectedProducts(areJudgedItems: areJudgedItems);
        ref.invalidate(provider);
      });
    });

    final items = ref.watch(
      provider.select((s) {
        return areJudgedItems
            ? s.value?.productsWithJudgementStatusRequestForFiscalNote
            : s.value?.productsWithoutJudgementStatusRequestForFiscalNote;
      }),
    );
    final selectedItemsIds = ref.watch(
      uiController.select(
        (s) => areJudgedItems
            ? s.selectedProductsWithJudgmentIds
            : s.selectedProductsWithoutJudgmentIds,
      ),
    );
    final grDocGroupCode = ref.watch(
      provider.select((state) => state.value?.code),
    );

    void onTapItem(BSFGRProductEntity item) {
      if (areJudgedItems) {
        ref.read(uiController.notifier).toggleProductWithJudgment(item.code);
      } else {
        ref.read(uiController.notifier).toggleProductWithoutJudgment(item.code);
      }
    }

    if (items?.isEmpty ?? true) {
      return Center(
        child: BaseText(
          areJudgedItems
              ? 'Não há produtos julgados'.hardcoded
              : 'Todos produtos já foram julgados'.hardcoded,
        ),
      );
    }

    final table = ScrollableTable<BSFGRProductEntity>(
      items: items!,
      fixFirstColumn: true,
      rowHeight: 65,
      refreshProvider: provider,
      rowColor: (item) =>
          selectedItemsIds.contains(item.code) ? Colors.green.shade100 : null,
      onTapRow: onTapItem,
      columns: [
        ScrollableTableColumnSpec<BSFGRProductEntity>(
          headerTitle: 'Produto'.hardcoded,
          minWidth: 200.0,
          cellBuilder: (item) {
            final texts = [
              BaseText.title(
                item.product.productPackingPriceLookUpString ?? '',
                color: context.theme.primaryColor,
              ),
              BaseText.title(
                " (${item.product.productPackingSpecificationString ?? ''})",
                color: context.theme.colorScheme.secondary,
              ),
              BaseText.title(" ${item.product.name ?? ''}"),
            ];

            return Text.rich(
              TextSpan(
                children: [
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Padding(
                      padding: const EdgeInsets.only(right: Sizes.p4),
                      child: BaseCheckBox(
                        name: '',
                        enabled: selectedItemsIds.contains(item.code),
                        onChanged: (_) => onTapItem(item),
                        width: Sizes.p16,
                        height: Sizes.p16,
                      ),
                    ),
                  ),
                  if (areJudgedItems)
                    TextSpan(
                      text:
                          "${item.judgementStatusRequestForFiscalNote.label} ",
                      style: const TextStyle(color: Colors.orange),
                    ),
                  ...texts.map(_buildTextSpan),
                ],
              ),
              maxLines: 3,
            );
          },
          sortValueMapper: (item) => item.productString,
        ),
        ScrollableTableColumnSpec<BSFGRProductEntity>(
          headerTitle: 'CFOP'.hardcoded,
          minWidth: 45,
          cellBuilder: (item) => BaseText(item.fiscalCode),
          sortValueMapper: (item) => item.fiscalCode,
        ),
        ScrollableTableColumnSpec<BSFGRProductEntity>(
          headerTitle: 'Qtd NF'.hardcoded,
          minWidth: 55,
          cellBuilder: (item) => BaseText(
            item.quantityOfXml.toString().toBrazilianNumber(3, true),
          ),
          footerCellBuilder: (items) => BaseText(
            items
                .map((e) => e.quantityOfXml)
                .reduce((a, b) => a + b)
                .toString()
                .toBrazilianNumber(3, true),
          ),
          sortValueMapper: (item) => item.quantityOfXml,
        ),
        ScrollableTableColumnSpec<BSFGRProductEntity>(
          headerTitle: 'Qtd ped'.hardcoded,
          minWidth: 60,
          cellBuilder: (item) => BaseText(
            item.availableQuantityInAssociatesBuyRequests
                .toString()
                .toBrazilianNumber(3, true),
          ),
          footerCellBuilder: (items) => BaseText(
            items
                .map((e) => e.availableQuantityInAssociatesBuyRequests)
                .reduce((a, b) => a + b)
                .toString()
                .toBrazilianNumber(3, true),
          ),
          sortValueMapper: (item) =>
              item.availableQuantityInAssociatesBuyRequests,
        ),
        ScrollableTableColumnSpec<BSFGRProductEntity>(
          headerTitle: 'Qtd outr ped'.hardcoded,
          minWidth: 95,
          cellBuilder: (item) => BaseText(
            item.availableQuantityInAnotherBuyRequests
                .toString()
                .toBrazilianNumber(3, true),
          ),
          footerCellBuilder: (items) => BaseText(
            items
                .map((e) => e.availableQuantityInAnotherBuyRequests)
                .reduce((a, b) => a + b)
                .toString()
                .toBrazilianNumber(3, true),
          ),
          sortValueMapper: (item) => item.availableQuantityInAnotherBuyRequests,
        ),
        ScrollableTableColumnSpec<BSFGRProductEntity>(
          headerTitle: 'Dif qtd'.hardcoded,
          minWidth: 60,
          cellBuilder: (item) => BaseText(
            item.divergenceQuantityRequestForFiscalNote
                .toString()
                .toBrazilianNumber(3, true),
            color: item.divergenceQuantityRequestForFiscalNote > 0
                ? context.theme.colorScheme.secondary
                : Colors.red,
          ),
          footerCellBuilder: (items) {
            final difference = items
                .map((e) => e.divergenceQuantityRequestForFiscalNote)
                .reduce((a, b) => a + b);
            return BaseText(
              difference.toString().toBrazilianNumber(3, true),
              color: difference > 0
                  ? context.theme.colorScheme.secondary
                  : Colors.red,
            );
          },
          sortValueMapper: (item) =>
              item.divergenceQuantityRequestForFiscalNote,
        ),
        ScrollableTableColumnSpec<BSFGRProductEntity>(
          headerTitle: 'Vl líq NF'.hardcoded,
          minWidth: 90,
          isMoney: true,
          cellBuilder: (item) =>
              BaseText(item.unitLiquidValue.toString().toBrazilianNumber()),
          footerCellBuilder: (items) => BaseText(
            items
                .map((e) => e.unitLiquidValue)
                .reduce((a, b) => a + b)
                .toString()
                .toBrazilianNumber(),
          ),
          sortValueMapper: (item) => item.unitLiquidValue,
        ),
        ScrollableTableColumnSpec<BSFGRProductEntity>(
          headerTitle: 'Vl líq ped'.hardcoded,
          minWidth: 90,
          isMoney: true,
          cellBuilder: (item) => BaseText(
            item.unitLiquidValueOnBuyRequests.toString().toBrazilianNumber(),
          ),
          footerCellBuilder: (items) => BaseText(
            items
                .map((e) => e.unitLiquidValueOnBuyRequests)
                .reduce((a, b) => a + b)
                .toString()
                .toBrazilianNumber(),
          ),
          sortValueMapper: (item) => item.unitLiquidValueOnBuyRequests,
        ),
        ScrollableTableColumnSpec<BSFGRProductEntity>(
          headerTitle: 'Dif vl líq'.hardcoded,
          minWidth: 80,
          isMoney: true,
          cellBuilder: (item) => BaseText(
            item.divergencyUnitLiquidValue.toString().toBrazilianNumber(),
            color: item.divergencyUnitLiquidValue > 0
                ? Colors.red
                : context.theme.colorScheme.secondary,
          ),
          footerCellBuilder: (items) {
            final totalDivergence = items
                .map((e) => e.divergencyUnitLiquidValue)
                .reduce((a, b) => a + b);
            return BaseText(
              totalDivergence.toString().toBrazilianNumber(),
              color: totalDivergence > 0
                  ? Colors.red
                  : context.theme.colorScheme.secondary,
            );
          },
          sortValueMapper: (item) => item.divergencyUnitLiquidValue,
        ),
        ScrollableTableColumnSpec<BSFGRProductEntity>(
          headerTitle: 'Tot dif vl líq'.hardcoded,
          minWidth: 100,
          isMoney: true,
          cellBuilder: (item) => BaseText(
            item.totalDivergencyLiquidValue.toString().toBrazilianNumber(),
            color: Colors.red,
          ),
          footerCellBuilder: (items) => BaseText(
            items
                .map((e) => e.totalDivergencyLiquidValue)
                .reduce((a, b) => a + b)
                .toString()
                .toBrazilianNumber(),
            color: Colors.red,
          ),
          sortValueMapper: (item) => item.totalDivergencyLiquidValue,
        ),
      ],
    );

    if (grDocGroupCode == null) {
      return table;
    }

    return Column(
      children: [
        Expanded(child: table),
        GRJudgmentButtons(
          processCode: processCode,
          areJudgedItems: areJudgedItems,
        ),
      ],
    );
  }
}
