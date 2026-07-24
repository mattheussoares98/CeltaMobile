import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/buy_movement/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/buy_movement/presentation/pages/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BuyMovementDetailsPage extends ConsumerWidget {
  final int enterpriseCode;
  final int buyMovementCode;
  const BuyMovementDetailsPage({
    super.key,
    required this.enterpriseCode,
    required this.buyMovementCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = buyMovementDetailsStateControllerProvider(buyMovementCode);
    final shallowBuyMovement = ref.watch(
      shallowBuyMovementStateControllerProvider(enterpriseCode).select(
        (s) => s.value?.firstWhereOrNull(
          (buyMovement) => buyMovement.code == buyMovementCode,
        ),
      ),
    );
    return BaseScaffold(
      isScrollable: false,
      refreshProvider: provider,
      appBar: BaseAppBar(
        title: ((shallowBuyMovement?.documentNumber ?? 0) > 0)
            ? 'Detalhes da compra (${shallowBuyMovement?.documentNumber ?? ''})'
                  .hardcoded
            : 'Detalhes da compra'.hardcoded,
        selectedEnterpriseCode: enterpriseCode,
      ),
      //TODO add bottomNavigationBar when it has buy request
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SearchedBuyMovementItem(buyMovement: shallowBuyMovement!),
          ),
          AsyncValueWidget(
            isSliver: true,
            value: ref.watch(provider),
            tryAgain: () => ref.invalidate(provider),
            data: (buyMovement) {
              return ResponsiveListFlow(
                isSliver: true,
                itemCount: buyMovement.products?.length ?? 0,
                itemBuilder: (context, index) {
                  final product = buyMovement.products![index];

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
                                  '(${product.priceLookupCode!}) '.hardcoded,
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
                                title: 'Qtd'.hardcoded,
                                value: product.quantity,
                              ),
                              SummaryTableItem(
                                title: 'Valor'.hardcoded,
                                value: product.value,
                                isPrice: true,
                              ),
                              SummaryTableItem(
                                title: 'Total'.hardcoded,
                                value: product.totalLiquid,
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
