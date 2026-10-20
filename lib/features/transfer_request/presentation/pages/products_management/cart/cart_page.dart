import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/request_type/request_type.dart';
import 'package:celta_inventario/features/transfer_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/transfer_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/transfer_request/presentation/pages/products_management/cart/components/components.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CartPage extends HookConsumerWidget {
  final DraftKey draftKey;
  const CartPage({super.key, required this.draftKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedProductIndex = useState<int?>(null);
    final requestTypeAllowChangePrice = ref.watch(
      requestTypeStateControllerProvider(
        Modules.transferRequest,
        draftKey.enterpriseOrigin,
      ).select(
        (s) =>
            s.value
                ?.firstWhereOrNull(
                  (request) => request.code == draftKey.requestTypeCode,
                )
                ?.allowAlterCostOrSalePrice ??
            false,
      ),
    );
    final productsInCartLength = ref.watch(
      cartProductsStateControllerProvider(
        draftKey,
      ).select((s) => s.value?.length ?? 0),
    );

    return productsInCartLength == 0
        ? Center(
            child: BaseText.titleMedium(
              context.l10n.noProductsAddedToTheCart,
              textAlign: TextAlign.center,
              color: Colors.red,
            ),
          )
        : CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: [
              Consumer(
                builder: (_, ref, _) {
                  return AsyncValueWidget(
                    isSliver: true,
                    value: ref.watch(
                      cartProductsStateControllerProvider(draftKey),
                    ),
                    tryAgain: () => ref.invalidate(
                      cartProductsStateControllerProvider(draftKey),
                    ),
                    data: (items) {
                      return ResponsiveListFlow(
                        isSliver: true,
                        itemCount: items.length,
                        padding: const EdgeInsets.only(bottom: Sizes.p80),
                        itemBuilder: (_, index) {
                          final item = items[index];

                          return ProductItem(
                            key: ValueKey(
                              '${item.product.ProductPackingCode}${item.product.EnterpriseCode}',
                            ),
                            item: item,
                            draftKey: draftKey,
                            requestTypeAllowChangePrice:
                                requestTypeAllowChangePrice,
                            isSelected: selectedProductIndex.value == index,
                            onSelectionChanged: () {
                              selectedProductIndex.value =
                                  selectedProductIndex.value == index
                                  ? null
                                  : index;
                            },
                            onUpdated: () => selectedProductIndex.value = null,
                          );
                        },
                      );
                    },
                  );
                },
              ),
              gapSliverH32,
            ],
          );
  }
}
