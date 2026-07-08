import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';
import 'package:celta_inventario/features/process_authorization/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProcessAuthorizationSaleRequestDiscountsPage
    extends ConsumerStatefulWidget {
  final int processCode;
  const ProcessAuthorizationSaleRequestDiscountsPage({
    super.key,
    required this.processCode,
  });

  @override
  ConsumerState<ProcessAuthorizationSaleRequestDiscountsPage> createState() =>
      _ProcessAuthorizationSaleRequestDiscountsPageState();
}

class _ProcessAuthorizationSaleRequestDiscountsPageState
    extends ConsumerState<ProcessAuthorizationSaleRequestDiscountsPage> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    super.dispose();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final provider =
        processAuthorizationSaleRequestErrorsStateControllerProvider(
          processCode: widget.processCode,
          errorType: SaleRequestErrorType.discount,
        );
    return BaseScaffold(
      refreshProvider: provider,
      isScrollable: false,
      usePadding: false,
      appBar: BaseAppBar(
        title: 'Análise de descontos no pedido'.hardcoded,
        showSelectedEnterprise: true,
      ),
      body: AsyncValueWidget(
        value: ref.watch(provider),
        tryAgain: () => ref.invalidate(provider),
        data: (data) {
          final discount = data.discount;
          final items = discount?.items ?? [];

          if (items.isEmpty) {
            return EmptyPlaceholderWidget(
              message: 'Nenhum desconto encontrado'.hardcoded,
            );
          }

          return ScrollableTable<BSFSaleRequestDiscountItemEntity>(
            items: items,
            fixFirstColumn: true,
            rowHeight: 45,
            refreshProvider: provider,
            columns: [
              ScrollableTableColumnSpec<BSFSaleRequestDiscountItemEntity>(
                headerTitle: 'Produto'.hardcoded,
                minWidth: 170.0,
                cellBuilder: (item) => BaseRichText(
                  texts: [
                    BaseText.title(
                      item.product.packingPriceLookUp,
                      color: context.theme.primaryColor,
                    ),
                    BaseText.title(
                      ' (${item.product.packingName})',
                      color: Colors.blue,
                    ),
                    BaseText.title(' ${item.product.name}'),
                  ],
                  maxLines: 2,
                ),
                sortValueMapper: (item) => item.product.name,
              ),
              ScrollableTableColumnSpec<BSFSaleRequestDiscountItemEntity>(
                headerTitle: 'Qtd'.hardcoded,
                minWidth: 50.0,
                cellBuilder: (item) => BaseText(
                  item.quantity.toString().toBrazilianNumber(3, true),
                ),
                sortValueMapper: (item) => item.quantity,
                footerCellBuilder: (items) => BaseText(
                  items
                      .fold<double>(0, (sum, item) => sum + item.quantity)
                      .toString()
                      .toBrazilianNumber(2, true),

                  fontWeight: FontWeight.bold,
                ),
              ),
              ScrollableTableColumnSpec<BSFSaleRequestDiscountItemEntity>(
                headerTitle: 'Bruto'.hardcoded,
                isMoney: true,
                minWidth: 80.0,
                cellBuilder: (item) =>
                    BaseText(item.bruteValue.toString().toBrazilianNumber(2)),
                sortValueMapper: (item) => item.bruteValue,
                footerCellBuilder: (items) => BaseText(
                  items
                      .fold<double>(0, (sum, item) => sum + item.bruteValue)
                      .toString()
                      .toBrazilianNumber(2),
                  fontWeight: FontWeight.bold,
                ),
              ),
              ScrollableTableColumnSpec<BSFSaleRequestDiscountItemEntity>(
                headerTitle: 'Desc'.hardcoded,
                isMoney: true,
                minWidth: 80.0,
                cellBuilder: (item) => BaseText(
                  item.discountValue.toString().toBrazilianNumber(2),
                ),
                sortValueMapper: (item) => item.discountValue,
                footerCellBuilder: (items) => BaseText(
                  items
                      .fold<double>(0, (sum, item) => sum + item.discountValue)
                      .toString()
                      .toBrazilianNumber(2),
                  fontWeight: FontWeight.bold,
                ),
              ),
              ScrollableTableColumnSpec<BSFSaleRequestDiscountItemEntity>(
                headerTitle: 'Desc'.hardcoded,
                isPercentage: true,
                minWidth: 60.0,
                cellBuilder: (item) => BaseText(
                  item.discountPercentage.toString().toBrazilianNumber(2, true),
                ),
                sortValueMapper: (item) => item.discountPercentage,
              ),
              ScrollableTableColumnSpec<BSFSaleRequestDiscountItemEntity>(
                headerTitle: 'Líquido'.hardcoded,
                isMoney: true,
                minWidth: 80.0,
                cellBuilder: (item) =>
                    BaseText(item.liquidValue.toString().toBrazilianNumber(2)),
                sortValueMapper: (item) => item.liquidValue,
                footerCellBuilder: (items) => BaseText(
                  items
                      .fold<double>(0, (sum, item) => sum + item.liquidValue)
                      .toString()
                      .toBrazilianNumber(2),
                  fontWeight: FontWeight.bold,
                ),
              ),
              ScrollableTableColumnSpec<BSFSaleRequestDiscountItemEntity>(
                headerTitle: 'Máx'.hardcoded,
                isPercentage: true,
                minWidth: 55.0,
                cellBuilder: (item) => BaseText(
                  item.discountConcessionLimitPercentage
                      .toString()
                      .toBrazilianNumber(2, true),
                ),
                sortValueMapper: (item) =>
                    item.discountConcessionLimitPercentage,
              ),
              ScrollableTableColumnSpec<BSFSaleRequestDiscountItemEntity>(
                headerTitle: 'Diferença'.hardcoded,
                isPercentage: true,
                minWidth: 80.0,
                cellBuilder: (item) => BaseText(
                  item.totalDifference.toString().toBrazilianNumber(2, true),
                  color: item.hasPositiveDifference ? Colors.red : Colors.green,
                ),
                sortValueMapper: (item) => item.totalDifference,
              ),
            ],
          );
        },
      ),
    );
  }
}
