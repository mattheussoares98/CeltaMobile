import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';
import 'package:celta_inventario/features/process_authorization/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProcessAuthorizationSaleRequestDiscountsPage extends ConsumerWidget {
  final int processCode;
  const ProcessAuthorizationSaleRequestDiscountsPage({
    super.key,
    required this.processCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider =
        processAuthorizationSaleRequestErrorsStateControllerProvider(
          processCode: processCode,
          errorType: SaleRequestErrorType.discount,
        );
    return BaseScaffold(
      refreshProvider: provider,
      isScrollable: false,
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
            columns: [
              ScrollableTableColumnSpec<BSFSaleRequestDiscountItemEntity>(
                headerTitle: 'Produto'.hardcoded,
                minWidth: 150.0,
                cellBuilder: (item) =>
                    BaseText(item.product, overflow: TextOverflow.ellipsis),
                sortValueMapper: (item) => item.product,
              ),
              ScrollableTableColumnSpec<BSFSaleRequestDiscountItemEntity>(
                headerTitle: 'Qtd'.hardcoded,
                minWidth: 60.0,
                cellBuilder: (item) => BaseText(
                  item.quantity.toString().toBrazilianNumber(2, true),
                ),
                sortValueMapper: (item) => item.quantity,
              ),
              ScrollableTableColumnSpec<BSFSaleRequestDiscountItemEntity>(
                headerTitle: 'Vl. Bruto'.hardcoded,
                minWidth: 90.0,
                cellBuilder: (item) =>
                    BaseText(item.bruteValue.toString().toBrazilianNumber(2)),
                sortValueMapper: (item) => item.bruteValue,
              ),
              ScrollableTableColumnSpec<BSFSaleRequestDiscountItemEntity>(
                headerTitle: 'Desc R\$'.hardcoded,
                minWidth: 90.0,
                cellBuilder: (item) => BaseText(
                  item.discountValue.toString().toBrazilianNumber(2),
                ),
                sortValueMapper: (item) => item.discountValue,
              ),
              ScrollableTableColumnSpec<BSFSaleRequestDiscountItemEntity>(
                headerTitle: 'Desc %'.hardcoded,
                minWidth: 70.0,
                cellBuilder: (item) => BaseText(
                  '${item.discountPercentage.toString().toBrazilianNumber(2)} %',
                ),
                sortValueMapper: (item) => item.discountPercentage,
              ),
              ScrollableTableColumnSpec<BSFSaleRequestDiscountItemEntity>(
                headerTitle: 'Vl. Líquido'.hardcoded,
                minWidth: 90.0,
                cellBuilder: (item) =>
                    BaseText(item.liquidValue.toString().toBrazilianNumber(2)),
                sortValueMapper: (item) => item.liquidValue,
              ),
              ScrollableTableColumnSpec<BSFSaleRequestDiscountItemEntity>(
                headerTitle: 'Limite %'.hardcoded,
                minWidth: 70.0,
                cellBuilder: (item) => BaseText(
                  '${item.discountConcessionLimitPercentage.toString().toBrazilianNumber(2)} %',
                ),
                sortValueMapper: (item) =>
                    item.discountConcessionLimitPercentage,
              ),
              ScrollableTableColumnSpec<BSFSaleRequestDiscountItemEntity>(
                headerTitle: 'Diferença'.hardcoded,
                minWidth: 90.0,
                cellBuilder: (item) => BaseText(
                  item.totalDifference.toString().toBrazilianNumber(2),
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
