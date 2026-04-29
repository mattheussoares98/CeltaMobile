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

class InsertProductPage extends ConsumerStatefulWidget {
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
  ConsumerState<InsertProductPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends ConsumerState<InsertProductPage> {
  late final TextEditingController _observationsController;

  @override
  void initState() {
    super.initState();

    _observationsController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(selectedProductStateControllerProvider.notifier)
          .setProduct(widget.product);
    });
  }

  @override
  void dispose() {
    _observationsController.dispose();
    super.dispose();
  }

  void _saveItem() {
    final uiState = ref.read(insertProductUIControllerProvider);
    final updatedItem = uiState.applyTo(
      ref.read(selectedProductStateControllerProvider)!,
    );

    ref
        .read(
          insertUpdateStateControllerProvider(
            enterpriseCode: widget.enterpriseCode,
            customerCode: widget.customerCode,
            saleRequestId: widget.saleRequestId,
          ).notifier,
        )
        .updateItem(widget.product, updatedItem);

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final provider = insertUpdateStateControllerProvider(
      enterpriseCode: widget.enterpriseCode,
      customerCode: widget.customerCode,
      saleRequestId: widget.saleRequestId,
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
        title: Text(
          widget.product.product?.name ?? 'Detalhe do Produto'.hardcoded,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.p8),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Hero(
                tag:
                    'sale_request_product_${widget.originalProduct.ProductPackingCode}',
                child: Material(
                  type: MaterialType.transparency,
                  child: ProductItemWidget(
                    product: widget.originalProduct,
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
            SliverToBoxAdapter(
              child: ObservationsField(controller: _observationsController),
            ),
            gapSliverH32,
            SliverToBoxAdapter(
              child: PrimaryButton(
                text: 'CONFIRMAR'.hardcoded,
                onPressed: _saveItem,
              ),
            ),
            const SliverToBoxAdapter(child: DefaultDivider()),
          ],
        ),
      ),
    );
  }
}
