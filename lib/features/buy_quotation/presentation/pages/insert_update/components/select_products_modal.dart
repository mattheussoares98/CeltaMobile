import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../core/presentation/controllers/products/products.dart';

class SelectProductsModal extends ConsumerStatefulWidget {
  final int enterpriseCode;
  final SearchProductKey searchProductKey;
  final void Function(List<ProductEntity> products) addProducts;
  const SelectProductsModal({
    super.key,
    required this.enterpriseCode,
    required this.searchProductKey,
    required this.addProducts,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectProductsModalState();
}

class _SelectProductsModalState extends ConsumerState<SelectProductsModal> {
  Map<String, dynamic> selectedProducts = {};
  //TODO test in the phone if is slow to improve it
  @override
  Widget build(BuildContext context) {
    final asyncValue = ref.watch(
      searchProductsStateControllerProvider(widget.searchProductKey),
    );
    return Scaffold(
      key: Key('select_products_${widget.enterpriseCode}_buy_quotation'),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(Sizes.p8, 0, Sizes.p8, Sizes.p8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: asyncValue.value?.length ?? 0,
                itemBuilder: (_, index) {
                  final product = asyncValue.value![index];
                  final productPacking = product.ProductPackingCode.toString();

                  void changeIsSelected() {
                    setState(() {
                      selectedProducts.containsKey(productPacking)
                          ? selectedProducts.remove(productPacking)
                          : selectedProducts[productPacking] = product;
                    });
                  }

                  return ProductItemWidget(
                    //TODO indicate when already is inserted
                    product: product,
                    routine: BsRoutine.buyQuotation,
                    showInfoButton: false,
                    onTap: changeIsSelected,
                    rightWidget: Checkbox(
                      value: selectedProducts.containsKey(productPacking),
                      onChanged: (_) => changeIsSelected(),
                    ),
                  );
                },
              ),
            ),
            PrimaryButton(
              text: 'Adicionar',
              onPressed: () {
                widget.addProducts(
                  selectedProducts.values
                      .map((e) => e as ProductEntity)
                      .toList(),
                );
                context.pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
