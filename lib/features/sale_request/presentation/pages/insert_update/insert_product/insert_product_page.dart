import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../../domain/entities/entities.dart';
import '../../../controllers/controllers.dart';
import 'components/components.dart';

class InsertProductPage extends ConsumerWidget {
  final BSFProductItemEntity product;
  final ProductEntity originalProduct;
  final int enterpriseCode;
  final int customerCode;
  final int saleRequestId;

  const InsertProductPage({
    super.key,
    required this.product,
    required this.originalProduct,
    required this.enterpriseCode,
    required this.customerCode,
    required this.saleRequestId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void saveItem() {
      final uiState = ref.read(insertProductUIControllerProvider(product));
      final updatedItem = uiState.applyTo(product);

      ref
          .read(
            insertUpdateStateControllerProvider(
              enterpriseCode: enterpriseCode,
              customerCode: customerCode,
              saleRequestId: saleRequestId,
            ).notifier,
          )
          .updateItem(product, updatedItem);

      context.pop();
    }

    final provider = insertUpdateStateControllerProvider(
      enterpriseCode: enterpriseCode,
      customerCode: customerCode,
      saleRequestId: saleRequestId,
    );

    final (
      allowPriceChange,
      allowDiscount,
      allowDeliveryTax,
      allowIncrement,
    ) = ref.watch(
      provider.select(
        (s) => (
          s.value?.requestType?.allowAlterCostOrSalePrice == true,
          s.value?.requestType?.allowUseDiscount == true,
          s.value?.requestType?.allowUseDeliveryTax == true,
          s.value?.requestType?.allowUseIncrement == true,
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(product.product?.name ?? 'Detalhe do Produto'.hardcoded),
      ),
      body: ResponsiveCenter(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.p8),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Hero(
                tag:
                    'sale_request_product_${originalProduct.ProductPackingCode}',
                child: Material(
                  type: MaterialType.transparency,
                  child: ProductItemWidget(
                    product: originalProduct,
                    routine: BsRoutine.saleRequest,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Row(
                children: [
                  Expanded(child: QuantityField(product: product)),
                  gapW8,
                  Expanded(
                    child: PriceField(
                      allowPriceChange: allowPriceChange,
                      product: product,
                    ),
                  ),
                ],
              ),
            ),
            if (allowDeliveryTax) ...[
              const SliverToBoxAdapter(child: DefaultDivider()),
              SliverToBoxAdapter(child: DeliveryTaxField(product: product)),
            ],
            if (allowDiscount) ...[
              const SliverToBoxAdapter(child: DefaultDivider()),
              SliverToBoxAdapter(child: AddDiscount(product: product)),
              Discounts(product: product),
            ],
            if (allowIncrement) ...[
              const SliverToBoxAdapter(child: DefaultDivider()),
              SliverToBoxAdapter(child: IncrementField(product: product)),
            ],
            const SliverToBoxAdapter(child: DefaultDivider()),
            gapSliverH32,
            SliverToBoxAdapter(
              child: ExcludeFocus(
                child: PrimaryButton(
                  text: 'CONFIRMAR'.hardcoded,
                  onPressed: saveItem,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
