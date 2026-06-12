// lib/features/sale_request/presentation/pages/insert_update/insert_product/insert_product_page.dart
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/sale_request/presentation/pages/insert_update/insert_product/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class InsertProductPage extends ConsumerWidget {
  final String? heroTag;
  final BSFProductItemEntity product;
  final ProductEntity originalProduct;
  final ProviderContainer container;

  const InsertProductPage({
    super.key,
    required this.product,
    required this.originalProduct,
    required this.container,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return UncontrolledProviderScope(
      container: container,
      child: ProviderScope(
        overrides: [currentProductItemProvider.overrideWithValue(product)],
        child: Consumer(
          builder: (_, ref, _) {
            void saveItem() async {
              final uiState = ref.read(
                insertProductUIControllerProvider(product),
              );
              final updatedItem = uiState.applyTo(product);

              final notifier = ref.read(
                insertUpdateStateControllerProvider.notifier,
              );

              final (errorMessage, actions) = notifier.updateItem(
                product,
                updatedItem,
                onlyValidating: true,
              );

              if (errorMessage?.isNotEmpty == true) {
                showSnackBarMessage(
                  context,
                  errorMessage!,
                  backgroundColor: Colors.red,
                );
                return;
              }

              if (actions.isNotEmpty) {
                final confirmed = await showAlertDialog(
                  context: context,
                  title: 'Atenção!'.hardcoded,
                  content: actions.map((e) => e.message).join('\n'),
                  cancelActionText: 'Cancelar'.hardcoded,
                  defaultActionText: 'Continuar'.hardcoded,
                );

                if (confirmed != true) {
                  return;
                }
              }

              notifier.updateItem(product, updatedItem, onlyValidating: false);

              if (context.mounted) {
                context.pop();
              }
            }

            final (
              allowPriceChange,
              allowDiscount,
              allowDeliveryTax,
              allowIncrement,
            ) = ref.watch(
              insertUpdateStateControllerProvider.select(
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
                title: Text(
                  product.product?.name ?? 'Detalhe do Produto'.hardcoded,
                ),
              ),
              body: ResponsiveCenter(
                padding: const EdgeInsets.symmetric(horizontal: Sizes.p8),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Hero(
                        tag:
                            heroTag ??
                            'product-${originalProduct.ProductPackingCode}',
                        child: Material(
                          type: MaterialType.transparency,
                          child: SingleChildScrollView(
                            child: ProductItemWidget(
                              product: originalProduct,
                              routine: BsRoutine.saleRequest,
                            ),
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
                            child: PriceField(
                              allowPriceChange: allowPriceChange,
                            ),
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
            );
          },
        ),
      ),
    );
  }
}
