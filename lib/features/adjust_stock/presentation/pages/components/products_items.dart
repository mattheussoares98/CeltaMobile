import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/products/products.dart';
import '../../../../../core/presentation/controllers/stock/stock.dart';
import '../../../../../utils/utils.dart';
import '../../controllers/controllers.dart';
import 'components.dart';

class ProductsItems extends ConsumerWidget {
  final SearchProductKey searchProductKey;
  final FocusNode quantityFocusNode;
  final GlobalKey<FormState> formKey;
  final int enterpriseCode;
  final TextEditingController quantityController;
  const ProductsItems({
    super.key,
    required this.searchProductKey,
    required this.quantityFocusNode,
    required this.formKey,
    required this.enterpriseCode,
    required this.quantityController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedUIState = ref.watch(
      selectedUIStateControllerProvider(enterpriseCode),
    );

    Future<void> confirmAdjust(ProductEntity product) async {
      if (formKey.currentState?.validate() != true) {
        return;
      }

      final selectedUIState = ref.read(
        selectedUIStateControllerProvider(enterpriseCode),
      );
      await ref.read(confirmAdjustStockControllerProvider.notifier).confirm([
        AdjustStockItemEntity(
          EnterpriseCode: enterpriseCode,
          ProductCode: product.ProductCode!,
          ProductPackingCode: product.ProductPackingCode!,
          JustificationCode:
              selectedUIState.selectedJustification!.CodigoInterno_JustMov,
          StockTypeCode:
              selectedUIState.selectedStockType!.CodigoInterno_TipoEstoque!,
          StockTypeRecipientCode: null,
          IsPendingAdjust: false,
          Quantity: quantityController.text.toDouble() ?? 0,
        ),
      ]);
    }

    return AsyncValueWidget(
      value: ref.watch(searchProductsStateControllerProvider(searchProductKey)),
      tryAgain: null,
      data: (products) {
        return ResponsiveListFlow(
          itemCount: products.length,
          itemBuilder: (_, index) {
            final product = products[index];
            return ProductItemWidget(
              product: product,
              routine: BsRoutine.adjustStock,
              onTap: () async {
                ref
                    .read(
                      selectedUIStateControllerProvider(
                        enterpriseCode,
                      ).notifier,
                    )
                    .updateValues(selectedIndex: index);
                await Future.delayed(const Duration(milliseconds: 100));
                quantityFocusNode.requestFocus();
              },
              showDropIcon: true,
              isSelected: selectedUIState.selectedIndex == index,
              notClickableBottom: selectedUIState.selectedIndex == index
                  ? ConfirmAdjustStock(
                      onConfirm: () => confirmAdjust(product),
                      quantityController: quantityController,
                      quantityFocusNode: quantityFocusNode,
                    )
                  : null,
            );
          },
        );
      },
    );
  }
}
