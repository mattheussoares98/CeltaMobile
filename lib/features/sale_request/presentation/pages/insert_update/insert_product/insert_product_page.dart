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
  final _observationsController = TextEditingController();
  final _quantityFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();
  final _deliveryFocusNode = FocusNode();
  final _discountFocusNode = FocusNode();
  final _incrementFocusNode = FocusNode();
  final _observationsFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(selectedProductStateControllerProvider.notifier)
          .setProduct(widget.product);
    });
  }

  @override
  void dispose() {
    _observationsController.dispose();
    _quantityFocusNode.dispose();
    _priceFocusNode.dispose();
    _deliveryFocusNode.dispose();
    _discountFocusNode.dispose();
    _incrementFocusNode.dispose();
    _observationsFocusNode.dispose();
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
      body: ResponsiveCenter(
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
                  Expanded(
                    child: QuantityField(
                      focusNode: _quantityFocusNode,
                      onFieldSubmitted: (_) => _priceFocusNode.requestFocus(),
                    ),
                  ),
                  gapW8,
                  Expanded(
                    child: PriceField(
                      allowPriceChange: allowPriceChange,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        if (allowDeliveryTax) {
                          _deliveryFocusNode.requestFocus();
                        } else if (allowDiscount) {
                          _discountFocusNode.requestFocus();
                        } else if (allowIncrement) {
                          _incrementFocusNode.requestFocus();
                        } else {
                          _observationsFocusNode.requestFocus();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (allowDeliveryTax) ...[
              const SliverToBoxAdapter(child: DefaultDivider()),
              SliverToBoxAdapter(
                child: DeliveryTaxField(
                  focusNode: _deliveryFocusNode,
                  onFieldSubmitted: (_) {
                    if (allowDiscount) {
                      _discountFocusNode.requestFocus();
                    } else if (allowIncrement) {
                      _incrementFocusNode.requestFocus();
                    } else {
                      _observationsFocusNode.requestFocus();
                    }
                  },
                ),
              ),
            ],
            if (allowDiscount) ...[
              const SliverToBoxAdapter(child: DefaultDivider()),
              SliverToBoxAdapter(
                child: AddDiscount(
                  focusNode: _discountFocusNode,
                  onFieldSubmitted: (_) {
                    if (allowIncrement) {
                      _incrementFocusNode.requestFocus();
                    } else {
                      _observationsFocusNode.requestFocus();
                    }
                  },
                ),
              ),
              const Discounts(),
            ],
            if (allowIncrement) ...[
              const SliverToBoxAdapter(child: DefaultDivider()),
              SliverToBoxAdapter(
                child: IncrementField(
                  focusNode: _incrementFocusNode,
                  onFieldSubmitted: (_) =>
                      _observationsFocusNode.requestFocus(),
                ),
              ),
            ],
            const SliverToBoxAdapter(child: DefaultDivider()),
            SliverToBoxAdapter(
              child: ObservationsField(
                controller: _observationsController,
                focusNode: _observationsFocusNode,
                onFieldSubmitted: (_) => _saveItem(),
              ),
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
