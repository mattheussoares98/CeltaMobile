import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../utils/utils.dart';
import '../../../../../enterprises/presentation/controllers/controllers.dart';
import '../../../../domain/entities/entities.dart';

class ProductsItems extends ConsumerWidget {
  final BuyQuotationEntity buyQuotation;
  const ProductsItems({super.key, required this.buyQuotation});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enterprises = ref.watch(enterprisesStateControllerProvider());
    final theme = Theme.of(context);

    return SliverList.builder(
      itemCount: buyQuotation.Products?.length ?? 0,
      itemBuilder: (_, index) {
        final product = buyQuotation.Products![index];

        return ProductItemWidget(
          product: product.Product!,
          routine: BsRoutine.buyQuotation,
          itemBeforeProductName: Column(
            children: [
              ...?product.ProductEnterprises?.map((e) {
                final correspondentEnterprise = enterprises.value!.firstWhere(
                  (x) => e.EnterpriseCode == x.Code,
                );
                return Row(
                  children: [
                    Expanded(
                      child: Text(
                        "(${correspondentEnterprise.PersonalizedCode}) - ${correspondentEnterprise.name}",
                        style: theme.textTheme.titleSmall,
                      ),
                    ),
                    Text((e.Quantity ?? 0).toString().toBrazilianNumber()),
                  ],
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
