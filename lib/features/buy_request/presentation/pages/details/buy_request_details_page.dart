import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
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
      refreshProvider: provider,
      appBar: BaseAppBar(
        title: (shallowBuyRequest?.personalizedCode?.isNotEmpty ?? false)
            ? 'Detalhes pedido (${shallowBuyRequest?.personalizedCode ?? ''})'
                  .hardcoded
            : 'Detalhes'.hardcoded,
        selectedEnterpriseCode: enterpriseCode,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SearchedBuyRequestItem(buyRequest: shallowBuyRequest!),
          ),
          AsyncValueWidget(
            isSliver: true,
            value: ref.watch(provider),
            tryAgain: () => ref.invalidate(provider),
            data: (buyRequest) {
              return ResponsiveListFlow(
                isSliver: true,
                itemCount: buyRequest.products?.length ?? 0,
                itemBuilder: (context, index) {
                  final product = buyRequest.products![index];

                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(Sizes.p8),
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          BaseRichText(
                            texts: [
                              if (product.priceLookupCode?.isNotEmpty ?? false)
                                BaseText.title(
                                  '(${product.priceLookupCode!}) ',
                                  color: context.theme.primaryColor,
                                ),
                              BaseText.title(product.name ?? ''),
                              BaseText.title(
                                ' (${product.packingName} ${product.packingQuantity.toString().toBrazilianNumber(3, true)})',
                                color: context.theme.colorScheme.secondary,
                              ),
                            ],
                          ),
                          SummaryTable(
                            items: [
                              SummaryTableItem(
                                title: 'Qtd',
                                value: product.quantity,
                              ),
                              SummaryTableItem(
                                title: 'Valor',
                                value: product.value,
                                isPrice: true,
                              ),
                              SummaryTableItem(
                                title: 'Total',
                                value: product.total,
                                isPrice: true,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
