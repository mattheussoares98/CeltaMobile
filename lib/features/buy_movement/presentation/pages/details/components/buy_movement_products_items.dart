import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/buy_movement/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BuyMovementProductsItems extends ConsumerWidget {
  final int buyMovementCode;
  const BuyMovementProductsItems({super.key, required this.buyMovementCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = buyMovementDetailsStateControllerProvider(buyMovementCode);

    return AsyncValueWidget(
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
                          ' (${product.packingName})',
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
                        SummaryTableItem(
                          title: 'CFOP'.hardcoded,
                          value: product.fiscalCode,
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
    );
  }
}
