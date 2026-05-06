// lib/features/sale_request/presentation/pages/insert_update/insert_product/insert_product_page.dart
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../domain/entities/entities.dart';
import '../../../controllers/controllers.dart';
import 'components/components.dart';

class InsertProductPage extends ConsumerWidget {
  final String? heroTag;
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
    this.heroTag,
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

    return ProviderScope(
      overrides: [currentProductItemProvider.overrideWithValue(product)],
      child: Scaffold(
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
                      heroTag ?? 'sale_request_product_${originalProduct.ProductPackingCode}',
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
                    const Expanded(child: QuantityField()),
                    gapW8,
                    Expanded(
                      child: PriceField(allowPriceChange: allowPriceChange),
                    ),
                  ],
                ),
              ),
              if (allowDeliveryTax) ...[
                const SliverToBoxAdapter(child: DefaultDivider()),
                const SliverToBoxAdapter(child: DeliveryTaxField()),
              ],
              if (allowDiscount) ...[
                const SliverToBoxAdapter(child: DefaultDivider()),
                const SliverToBoxAdapter(child: AddDiscount()),
                const Discounts(),
              ],
              if (allowIncrement) ...[
                const SliverToBoxAdapter(child: DefaultDivider()),
                const SliverToBoxAdapter(child: IncrementField()),
              ],
              const SliverToBoxAdapter(child: DefaultDivider()),
              const SliverToBoxAdapter(child: ProductSummary()),
              gapSliverH16,
              SliverToBoxAdapter(
                child: ExcludeFocus(
                  child: PrimaryButton(
                    text: 'CONFIRMAR'.hardcoded,
                    onPressed: saveItem,
                  ),
                ),
              ),
              gapSliverH16,
            ],
          ),
        ),
      ),
    );
  }
}
