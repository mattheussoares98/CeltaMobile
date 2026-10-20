import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/products/products.dart';
import 'package:celta_inventario/core/presentation/controllers/request_type/request_type.dart';
import 'package:celta_inventario/features/transfer_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/transfer_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/transfer_request/presentation/pages/products_management/insert_products/components/product_item.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProductsItems extends HookConsumerWidget {
  final DraftKey draftKey;
  final SearchProductKey searchProductKey;
  const ProductsItems({
    super.key,
    required this.draftKey,
    required this.searchProductKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quantityController = useTextEditingController();
    final priceController = useTextEditingController();
    final quantityFocusNode = useFocusNode();
    final priceFocusNode = useFocusNode();
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final selectedProductIndex = useState<int?>(null);
    final requests = ref.watch(
      requestTypeStateControllerProvider(
        Modules.transferRequest,
        draftKey.enterpriseOrigin,
      ),
    );
    final requestTypeAllowChangePrice =
        requests.value
            ?.firstWhereOrNull(
              (request) => request.code == draftKey.requestTypeCode,
            )
            ?.allowAlterCostOrSalePrice ==
        true;

    ref.listen(searchProductsStateControllerProvider(searchProductKey), (p, n) {
      selectedProductIndex.value = null;
    });

    void onTap(
      TransferRequestProductItemEntity? transferRequestItem,
      ProductEntity product,
      int index,
    ) {
      if (product.Value == 0 && !requestTypeAllowChangePrice) {
        showToastMessage(
          context.l10n.thisProductHasAZeroPriceAndTheSelectedOrder,
          type: ToastType.error,
        );
        selectedProductIndex.value = null;
        return;
      }

      FocusManager.instance.primaryFocus?.unfocus();
      selectedProductIndex.value = selectedProductIndex.value == index
          ? null
          : index;
      priceController.clear();
      quantityController.clear();

      if (product.Value! > 0 || transferRequestItem?.value != null) {
        final price = transferRequestItem?.value ?? product.Value;
        priceController.text = price.toString().toBrazilianNumber().replaceAll(
          RegExp(r'\.'),
          '',
        );
      }

      quantityFocusNode.unfocus();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        quantityFocusNode.requestFocus();
      });
    }

    void update(ProductEntity product) {
      if (formKey.currentState?.validate() != true) return;

      final newQuantity = quantityController.text.toDouble() ?? 0;
      final value = priceController.text.toDouble() ?? product.Value;
      ref
          .read(cartProductsStateControllerProvider(draftKey).notifier)
          .addItem(
            TransferRequestProductItemEntity(
              product: product,
              quantity: newQuantity,
              value: value!,
            ),
            CartAdditionStrategy.increase,
          );
      selectedProductIndex.value = null;
    }

    return AsyncValueWidget(
      isSliver: true,
      value: ref.watch(searchProductsStateControllerProvider(searchProductKey)),
      tryAgain: null,
      data: (products) {
        return ResponsiveListFlow(
          isSliver: true,
          itemCount: products.length,
          itemBuilder: (_, index) {
            final product = products[index];

            return ProductItem(
              key: ValueKey(
                '${product.ProductPackingCode}${product.EnterpriseCode}',
              ),
              product: product,
              draftKey: draftKey,
              isSelected: selectedProductIndex.value == index,
              requestTypeAllowChangePrice: requestTypeAllowChangePrice,
              onTap: (transferRequestItem) =>
                  onTap(transferRequestItem, product, index),
              quantityController: quantityController,
              priceController: priceController,
              quantityFocusNode: quantityFocusNode,
              priceFocusNode: priceFocusNode,
              formKey: formKey,
              update: () => update(product),
            );
          },
        );
      },
    );
  }
}
