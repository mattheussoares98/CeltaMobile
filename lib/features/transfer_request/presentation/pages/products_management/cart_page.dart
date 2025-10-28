import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final pendingAsync = ref.watch(
      pendingTransferRequestStateControllerProvider(
        DraftKey(
          requestTypeCode: insertProductsPage.requestTypeCode,
          enterpriseOrigin: insertProductsPage.enterpriseOriginCode,
          enterpriseDestinyCode: insertProductsPage.enterpriseDestinyCode,
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(Sizes.p8),
      child: Column(
        children: [
          Expanded(
            child: ProductsItems(
              products:
                  pendingAsync.value?.map((e) => e.product).toList() ?? [],
              selectedIndex: insertProductsPage.selectedProductIndex,
              onTap: insertProductsPage.onTapProductItem,
              removeItem: insertProductsPage.removeProductItem,
              requestTypeAllowChangePrice:
                  insertProductsPage.requestTypeAllowChangePrice,
              insertProductsPage: insertProductsPage,
            ),
          ),
          Footer(insertProductsPage: insertProductsPage),
        ],
      ),
    );
  }
}
