import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  late final TextEditingController _incrementValueController;

  @override
  void initState() {
    super.initState();

    final product = widget.product;
    _observationsController = TextEditingController();

    _incrementValueController = TextEditingController(
      text: (product.increment?.value ?? 0).toString(),
    );
  }

  @override
  void dispose() {
    _observationsController.dispose();
    _incrementValueController.dispose();
    super.dispose();
  }

  void _saveItem() {
    final uiController = ref.read(
      insertProductUIControllerProvider(product: widget.product).notifier,
    );

    uiController.updateObservations(_observationsController.text);
    uiController.updateIncrementValue(
      double.tryParse(_incrementValueController.text) ?? 0,
    );

    final updatedItem = uiController.getUpdatedProduct();

    ref
        .read(
          insertUpdateStateControllerProvider(
            enterpriseCode: widget.enterpriseCode,
            customerCode: widget.customerCode,
            saleRequestId: widget.saleRequestId,
          ).notifier,
        )
        .updateItem(widget.product, updatedItem);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final provider = insertUpdateStateControllerProvider(
      enterpriseCode: widget.enterpriseCode,
      customerCode: widget.customerCode,
      saleRequestId: widget.saleRequestId,
    );

    final requestType = ref.watch(
      provider.select((v) => v.whenData((data) => data.requestType)),
    );

    final allowPriceChange =
        requestType.value?.allowAlterCostOrSalePrice == true;
    final allowDiscount = requestType.value?.allowUseDiscount == true;
    final allowDeliveryTax = requestType.value?.allowUseDeliveryTax == true;
    final allowIncrement = requestType.value?.allowUseIncrement == true;

    final uiProvider = insertProductUIControllerProvider(
      product: widget.product,
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
                  Expanded(child: QuantityField(product: widget.product)),
                  gapW8,
                  Expanded(
                    child: PriceField(
                      product: widget.product,
                      allowPriceChange: allowPriceChange,
                    ),
                  ),
                ],
              ),
            ),
            if (allowDeliveryTax)
              SliverToBoxAdapter(
                child: DeliveryTaxField(product: widget.product),
              ),
            if (allowDiscount) ...[
              gapSliverH8,
              SliverToBoxAdapter(child: AddDiscount(product: widget.product)),
              gapSliverH8,
              Discounts(product: widget.product),
            ],
            if (allowIncrement) ...[
              gapSliverH8,
              Consumer(
                builder: (context, ref, _) {
                  final incrementType = ref.watch(
                    uiProvider.select((s) => s.incrementType),
                  );
                  return SliverToBoxAdapter(
                    child: IncrementField(
                      controller: _incrementValueController,
                      type: incrementType,
                      onTypeChanged: (type) => ref
                          .read(uiProvider.notifier)
                          .updateIncrementType(type),
                    ),
                  );
                },
              ),
            ],
            gapSliverH8,
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
            gapSliverH8,
          ],
        ),
      ),
    );
  }
}
