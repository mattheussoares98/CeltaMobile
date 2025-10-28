import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../domain/entities/entities.dart';
import '../../controllers/controllers.dart';
import '../pages.dart';
import 'components/components.dart';

class CartPage extends ConsumerWidget {
  final InsertProductsPage insertProductsPage;
  const CartPage({super.key, required this.insertProductsPage});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      insertTransferRequestControllerProvider(
        DraftKey(
          requestTypeCode: insertProductsPage.requestTypeCode,
          enterpriseOrigin: insertProductsPage.enterpriseOriginCode,
          enterpriseDestinyCode: insertProductsPage.enterpriseDestinyCode,
        ),
      ),
      (p, n) {
        n.doOnSuccess(p, () {
          showSnackBarMessage(context, 'Pedido salvo com sucesso'.hardcoded);
        });
      },
    );

    final pendingAsync = ref.watch(
      cartProductsStateControllerProvider(
        DraftKey(
          requestTypeCode: insertProductsPage.requestTypeCode,
          enterpriseOrigin: insertProductsPage.enterpriseOriginCode,
          enterpriseDestinyCode: insertProductsPage.enterpriseDestinyCode,
        ),
      ),
    );

    final products = pendingAsync.value?.map((e) => e.product).toList() ?? [];

    final lastSavedAsync = ref.watch(lastSavedNumberStateControllerProvider);

    return Padding(
      padding: const EdgeInsets.all(Sizes.p8),
      child: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                if (lastSavedAsync.value != null)
                  LastSavedNumber(number: lastSavedAsync.value!),
                ProductsItems(
                  products: products,
                  selectedIndex: insertProductsPage.selectedProductIndex,
                  onTap: insertProductsPage.onTapProductItem,
                  removeItem: insertProductsPage.removeProductItem,
                  requestTypeAllowChangePrice:
                      insertProductsPage.requestTypeAllowChangePrice,
                  insertProductsPage: insertProductsPage,
                ),
                if (products.length > 2) ...[
                  ClearCartButton(insertProductsPage: insertProductsPage),
                  gapSliverH16,
                ],
              ],
            ),
          ),
          Footer(insertProductsPage: insertProductsPage),
        ],
      ),
    );
  }
}
