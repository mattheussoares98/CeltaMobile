import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/buy_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/buy_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/buy_request/presentation/pages/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BuyRequestDetailsPage extends ConsumerWidget {
  final int enterpriseCode;
  final int buyRequestCode;
  const BuyRequestDetailsPage({
    super.key,
    required this.enterpriseCode,
    required this.buyRequestCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = buyRequestDetailsStateControllerProvider(buyRequestCode);
    final shallowBuyRequest = ref.watch(
      shallowBuyRequestStateControllerProvider(enterpriseCode).select(
        (s) => s.value?.firstWhereOrNull(
          (buyRequest) => buyRequest.code == buyRequestCode,
        ),
      ),
    );
    return BaseScaffold(
      isScrollable: false,
      usePadding: false,
      refreshProvider: provider,
      appBar: BaseAppBar(
        title: (shallowBuyRequest?.personalizedCode?.isNotEmpty ?? false)
            ? 'Detalhes pedido (${shallowBuyRequest?.personalizedCode ?? ''})'
                  .hardcoded
            : 'Detalhes'.hardcoded,
        selectedEnterpriseCode: enterpriseCode,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(Sizes.p4),
            child: SearchedBuyRequestItem(buyRequest: shallowBuyRequest!),
          ),
          AsyncValueWidget(
            value: ref.watch(provider),
            tryAgain: () => ref.invalidate(provider),
            data: (buyRequest) {
              return Expanded(
                child: ScrollableTable<EcBuyRequestProductDtoEntity>(
                  fixFirstColumn: true,
                  rowHeight: 45,
                  refreshProvider: provider,
                  items: buyRequest.products ?? [],
                  headerHeight: 30,
                  columns: [
                    if ((buyRequest.enterprises?.length ?? 1) > 1)
                      ScrollableTableColumnSpec(
                        headerTitle: 'Empresa'.hardcoded,
                        minWidth: 45,
                        cellBuilder: (item) => BaseRichText(
                          texts: [
                            BaseText.title(
                              '${item.enterprisePersonalizedCode} - ${item.enterpriseName}',
                            ),
                          ],
                        ),
                        sortValueMapper: (item) =>
                            '${item.enterprisePersonalizedCode} - ${item.enterpriseName}',
                      ),
                    ScrollableTableColumnSpec(
                      headerTitle: 'Produto'.hardcoded,
                      minWidth: 100,
                      cellBuilder: (item) => BaseRichText(
                        maxLines: 2,
                        texts: [
                          if (item.priceLookupCode?.isNotEmpty ?? false)
                            BaseText.bodySmall(
                              '(${item.priceLookupCode!})',
                              color: context.theme.primaryColor,
                            ),
                          BaseText.bodySmall(
                            ' (${item.packingName} ${item.packingQuantity.toString().toBrazilianNumber(3, true)}) ',
                            color: context.theme.colorScheme.secondary,
                          ),
                          BaseText.bodySmall(item.name ?? ''),
                        ],
                      ),
                      sortValueMapper: (item) =>
                          '${item.name}${item.packingName}${item.packingQuantity}',
                    ),
                    ScrollableTableColumnSpec(
                      headerTitle: 'Qtd'.hardcoded,
                      minWidth: 45,
                      cellBuilder: (item) => BaseRichText(
                        texts: [
                          BaseText.title(
                            item.quantity.toString().toBrazilianNumber(3, true),
                          ),
                        ],
                      ),
                      sortValueMapper: (item) =>
                          item.quantity.toString().toBrazilianNumber(3, true),
                    ),
                    ScrollableTableColumnSpec(
                      headerTitle: 'Valor'.hardcoded,
                      minWidth: 55,
                      isMoney: true,
                      footerCellBuilder: (items) {
                        final total = items.fold(
                          0.0,
                          (p, e) => p + (e.value ?? 0),
                        );
                        return BaseText.title(
                          total.toString().toBrazilianNumber(),
                        );
                      },
                      cellBuilder: (item) => BaseText.title(
                        item.value.toString().toBrazilianNumber(),
                      ),
                      sortValueMapper: (item) =>
                          item.value.toString().toBrazilianNumber(),
                    ),
                    ScrollableTableColumnSpec(
                      headerTitle: 'Total'.hardcoded,
                      minWidth: 55,
                      isMoney: true,
                      cellBuilder: (item) => BaseText.title(
                        item.total.toString().toBrazilianNumber(),
                      ),
                      sortValueMapper: (item) =>
                          item.value.toString().toBrazilianNumber(),
                      footerCellBuilder: (items) {
                        final total = items.fold(
                          0.0,
                          (p, e) => p + (e.total ?? 0),
                        );
                        return BaseText.title(
                          total.toString().toBrazilianNumber(),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
