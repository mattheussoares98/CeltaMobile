import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/buy_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BuyRequestProductsItems extends ConsumerWidget {
  final int buyRequestCode;
  const BuyRequestProductsItems({super.key, required this.buyRequestCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = buyRequestDetailsStateControllerProvider(buyRequestCode);
    return AsyncValueWidget(
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
                          title: context.l10n.quantityShort,
                          value: product.quantity,
                        ),
                        SummaryTableItem(
                          title: context.l10n.amount,
                          value: product.value,
                          isPrice: true,
                        ),
                        SummaryTableItem(
                          title: context.l10n.total,
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
    );
  }
}
