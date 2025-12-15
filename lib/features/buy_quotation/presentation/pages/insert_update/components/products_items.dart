import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../../../../utils/utils.dart';
import '../../../../../enterprises/presentation/controllers/controllers.dart';
import '../../../../domain/entities/entities.dart';
import '../../../controllers/controller.dart';

class ProductsItems extends ConsumerWidget {
  final BuyQuotationEntity buyQuotation;
  final Map<String, TextEditingController> quantityControllers;
  final int enterpriseCode;
  const ProductsItems({
    super.key,
    required this.buyQuotation,
    required this.quantityControllers,
    required this.enterpriseCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enterprises = ref.watch(enterprisesStateControllerProvider());
    final theme = Theme.of(context);
    final selectedIndex = ref.watch(
      selectedProductIndexStateControllerProvider,
    );

    return SliverList.builder(
      itemCount: buyQuotation.Products?.length ?? 0,
      itemBuilder: (_, index) {
        final product = buyQuotation.Products![index];

        return ProductItemWidget(
          product: product.Product!,
          routine: BsRoutine.buyQuotation,
          showDropIcon: true,
          isSelected: index == selectedIndex,
          onTap: () {
            ref
                .read(selectedProductIndexStateControllerProvider.notifier)
                .updateIndex(index);
          },
          itemBeforeProductName: Column(
            children: [
              ...?product.ProductEnterprises?.where(
                (x) =>
                    buyQuotation.Enterprises?.any(
                      (y) => y.enterprise.Code == x.EnterpriseCode,
                    ) ==
                    true,
              ).map((e) {
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
          notClickableBottom: index == selectedIndex
              ? Column(
                  children: quantityControllers.entries
                      .where(
                        (e) =>
                            buyQuotation.Enterprises?.any(
                              (y) => y.enterprise.Code.toString() == e.key,
                            ) ==
                            true,
                      )
                      .map((entry) {
                        final correspondentEnterprise = enterprises.value!
                            .firstWhere((x) => entry.key == x.Code.toString());
                        return DefaultTextFormField(
                          controller: entry.value,
                          keyboardType: TextInputType.number,
                          labelText:
                              '(${correspondentEnterprise.PersonalizedCode}) ${correspondentEnterprise.name}'
                                  .hardcoded,
                        );
                      })
                      .toList(),
                )
              : null,
        );
      },
    );
  }
}
