import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/process_authorization/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/receipt/domain/entity/entity.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GoodsReceivingValidateDocXmlPage extends ConsumerWidget {
  final int processCode;
  const GoodsReceivingValidateDocXmlPage({
    super.key,
    required this.processCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = gRDocFiscalNoteDifferencesStateControllerProvider(
      processCode,
    );
    return BaseScaffold(
      isScrollable: false,
      refreshProvider: provider,
      usePadding: false,
      appBar: BaseAppBar(title: 'Diferenças de XML'.hardcoded),
      body: AsyncValueWidget(
        value: ref.watch(provider),
        tryAgain: () => ref.invalidate(provider),
        data: (data) {
          if (data.products?.isEmpty ?? true) {
            return BaseText.error(
              'Houve um erro não esperado para carregar os produtos'.hardcoded,
            );
          }

          return ScrollableTable<BSFGoodsReceivingProductEntity>(
            items: data.products!,
            fixFirstColumn: true,
            rowHeight: 45,
            refreshProvider: provider,
            columns: [
              ScrollableTableColumnSpec<BSFGoodsReceivingProductEntity>(
                headerTitle: 'Produto'.hardcoded,
                minWidth: 170.0,
                cellBuilder: (item) => BaseRichText(
                  texts: [
                    BaseText.title(
                      item.product.productPackingPriceLookUpString ?? '',
                      color: context.theme.primaryColor,
                    ),
                    BaseText.title(
                      " (${item.product.productPackingSpecificationString ?? ''})",
                      color: context.theme.colorScheme.secondary,
                    ),
                    BaseText.title(" ${item.product.name ?? ''}"),
                  ],
                  maxLines: 2,
                ),
                sortValueMapper: (item) => item.productString,
              ),
              ScrollableTableColumnSpec<BSFGoodsReceivingProductEntity>(
                headerTitle: 'CFOP'.hardcoded,
                minWidth: 45,
                cellBuilder: (item) => BaseText(item.fiscalCode),
                sortValueMapper: (item) => item.fiscalCode,
              ),
              ScrollableTableColumnSpec<BSFGoodsReceivingProductEntity>(
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
              ScrollableTableColumnSpec<BSFGoodsReceivingProductEntity>(
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
              ScrollableTableColumnSpec<BSFGoodsReceivingProductEntity>(
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
                sortValueMapper: (item) =>
                    item.availableQuantityInAnotherBuyRequests,
              ),
              ScrollableTableColumnSpec<BSFGoodsReceivingProductEntity>(
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
              ScrollableTableColumnSpec<BSFGoodsReceivingProductEntity>(
                headerTitle: 'Vl líq NF'.hardcoded,
                minWidth: 90,
                isMoney: true,
                cellBuilder: (item) => BaseText(
                  item.unitLiquidValue.toString().toBrazilianNumber(),
                ),
                footerCellBuilder: (items) => BaseText(
                  items
                      .map((e) => e.unitLiquidValue)
                      .reduce((a, b) => a + b)
                      .toString()
                      .toBrazilianNumber(),
                ),
                sortValueMapper: (item) => item.unitLiquidValue,
              ),
              ScrollableTableColumnSpec<BSFGoodsReceivingProductEntity>(
                headerTitle: 'Vl líq ped'.hardcoded,
                minWidth: 90,
                isMoney: true,
                cellBuilder: (item) => BaseText(
                  item.unitLiquidValueOnBuyRequests
                      .toString()
                      .toBrazilianNumber(),
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
              ScrollableTableColumnSpec<BSFGoodsReceivingProductEntity>(
                headerTitle: 'Dif vl líq'.hardcoded,
                minWidth: 80,
                isMoney: true,
                cellBuilder: (item) => BaseText(
                  item.divergencyUnitLiquidValue.toString().toBrazilianNumber(),
                  color: Colors.red,
                ),
                footerCellBuilder: (items) => BaseText(
                  items
                      .map((e) => e.divergencyUnitLiquidValue)
                      .reduce((a, b) => a + b)
                      .toString()
                      .toBrazilianNumber(),
                  color: Colors.red,
                ),
                sortValueMapper: (item) => item.divergencyUnitLiquidValue,
              ),
              ScrollableTableColumnSpec<BSFGoodsReceivingProductEntity>(
                headerTitle: 'Tot dif vl líq'.hardcoded,
                minWidth: 100,
                isMoney: true,
                cellBuilder: (item) => BaseText(
                  item.totalDivergencyLiquidValue
                      .toString()
                      .toBrazilianNumber(),
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
        },
      ),
    );
  }
}
