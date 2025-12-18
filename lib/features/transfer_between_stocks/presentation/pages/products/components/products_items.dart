import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../core/presentation/controllers/products/products.dart';
import '../../../../../../utils/utils.dart';
import '../../../../domain/entities/entities.dart';
import '../../../controllers/controllers.dart';
import '../components/components.dart';

class ProductsItems extends ConsumerWidget {
  final SearchProductKey searchProductKey;
  final int enterpriseCode;
  final TextEditingController quantityController;
  final GlobalKey<FormState> formKey;
  final FocusNode quantityFocusNode;
  const ProductsItems({
    super.key,
    required this.searchProductKey,
    required this.enterpriseCode,
    required this.quantityController,
    required this.formKey,
    required this.quantityFocusNode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(
      selectedProductUIStateControllerProvider(
        enterpriseCode,
      ).select((s) => s.productIndex),
    );
    final theme = Theme.of(context);

    Future<void> addInLot(ProductEntity product) async {
      if (formKey.currentState?.validate() != true) {
        return;
      }

      ref
          .read(lotStateControllerProvider(enterpriseCode).notifier)
          .addItem(
            product: product,
            quantity: quantityController.text.toDouble() ?? 0,
          );

      quantityController.clear();
      ref
          .read(
            selectedProductUIStateControllerProvider(enterpriseCode).notifier,
          )
          .updateValues(productIndex: null);
    }

    return AsyncValueWidget(
      value: ref.watch(searchProductsStateControllerProvider(searchProductKey)),
      tryAgain: null,
      data: (products) {
        return Consumer(
          builder: (_, ref, _) {
            final lotAsync = ref.watch(
              lotStateControllerProvider(enterpriseCode),
            );
            return ResponsiveListFlow(
              maxItemWidth: 380,
              itemCount: products.length,
              itemBuilder: (_, index) {
                final product = products[index];

                final productInLotIndex = lotAsync.value?.indexWhere(
                  (e) =>
                      e.product.ProductPackingCode ==
                      product.ProductPackingCode,
                );
                ProductLotInfoEntity? lotItem;
                if (productInLotIndex != -1 && productInLotIndex != null) {
                  lotItem = lotAsync.value?[productInLotIndex];
                }

                return ProductItemWidget(
                  product: product,
                  routine: BsRoutine.adjustStock,
                  onTap: () {
                    ref
                        .read(
                          selectedProductUIStateControllerProvider(
                            enterpriseCode,
                          ).notifier,
                        )
                        .updateValues(productIndex: index);
                    Future.delayed(
                      Duration.zero,
                      () => quantityFocusNode.requestFocus(),
                    );
                  },
                  showDropIcon: true,
                  isSelected: selectedIndex == index,
                  clickableBottom: lotItem == null
                      ? null
                      : Text(
                          '${lotItem.quantity.toString().toBrazilianNumber()} qtds no lote',
                          textAlign: TextAlign.start,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: Colors.blue,
                          ),
                        ),
                  notClickableBottom: selectedIndex == index
                      ? Padding(
                          padding: const EdgeInsets.only(top: Sizes.p8),
                          child: AddInLot(
                            productIsAlreadyInLot: lotItem != null,
                            addInLot: () => addInLot(product),
                            quantityController: quantityController,
                            quantityFocusNode: quantityFocusNode,
                          ),
                        )
                      : null,
                );
              },
            );
          },
        );
      },
    );
  }
}
