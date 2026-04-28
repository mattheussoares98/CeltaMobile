import 'package:flutter/cupertino.dart';
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
  late BSFProductItemEntity _editedItem;
  late final TextEditingController _quantityController;
  late final TextEditingController _priceController;
  late final TextEditingController _observationsController;
  late final TextEditingController _deliveryTaxValueController;
  late final TextEditingController _incrementValueController;

  final _deliveryTaxType = ValueNotifier<PercentageOrValue>(
    PercentageOrValue.value,
  );
  final _incrementType = ValueNotifier<PercentageOrValue>(
    PercentageOrValue.value,
  );
  final _discounts = ValueNotifier<List<BSFDiscountEntity>>([]);
  //TODO create a new controller to manage this page UI state

  @override
  void initState() {
    super.initState();
    _editedItem = widget.product;

    _discounts.value = _editedItem.discounts ?? [];
    _quantityController = TextEditingController(
      text: (_editedItem.quantity ?? 1).toString(),
    );
    _priceController = TextEditingController(
      text: (_editedItem.value ?? 0).toString(),
    );

    _observationsController = TextEditingController();

    _deliveryTaxValueController = TextEditingController(
      text: (_editedItem.deliveryTax?.value ?? 0).toString(),
    );
    _deliveryTaxType.value =
        _editedItem.deliveryTax?.type ?? PercentageOrValue.value;

    _incrementValueController = TextEditingController(
      text: (_editedItem.increment?.value ?? 0).toString(),
    );
    _incrementType.value =
        _editedItem.increment?.type ?? PercentageOrValue.value;
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _priceController.dispose();
    _observationsController.dispose();
    _deliveryTaxValueController.dispose();
    _incrementValueController.dispose();
    super.dispose();
  }

  void _saveItem() {
    final quantity = double.tryParse(_quantityController.text) ?? 1;
    final price =
        double.tryParse(_priceController.text) ?? _editedItem.value ?? 0;
    final deliveryTaxValue =
        double.tryParse(_deliveryTaxValueController.text) ?? 0;
    final incrementValue = double.tryParse(_incrementValueController.text) ?? 0;

    final updatedItem = _editedItem.copyWith(
      quantity: quantity,
      value: price,
      deliveryTax: deliveryTaxValue > 0
          ? BSFValueTypeEntity(
              type: _deliveryTaxType.value,
              value: deliveryTaxValue,
            )
          : null,
      increment: incrementValue > 0
          ? BSFValueTypeEntity(
              type: _incrementType.value,
              value: incrementValue,
            )
          : null,
    );

    ref
        .read(
          insertUpdateStateControllerProvider(
            enterpriseCode: widget.enterpriseCode,
            customerCode: widget
                .customerCode, //TODO dont make sense this here. Should remove
            saleRequestId: widget.saleRequestId,
          ).notifier,
        )
        .updateItem(widget.product, updatedItem);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _editedItem.product?.name ?? 'Detalhe do Produto'.hardcoded,
        ),
        leading: IconButton(
          icon: Icon(isIOS ? CupertinoIcons.back : Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ResponsiveScrollableWidget(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.p8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Hero(
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
              if (allowDeliveryTax) ...[
                ValueListenableBuilder(
                  valueListenable: _deliveryTaxType,
                  builder: (context, value, _) {
                    return DeliveryTaxField(
                      controller: _deliveryTaxValueController,
                      type: value,
                      onTypeChanged: (type) => _deliveryTaxType.value = type,
                    );
                  },
                ),
              ],
              gapH8,
              Row(
                children: [
                  Expanded(
                    child: QuantityField(controller: _quantityController),
                  ),
                  gapW8,
                  Expanded(
                    child: PriceField(
                      controller: _priceController,
                      enabled: allowPriceChange,
                    ),
                  ),
                ],
              ),
              if (allowDiscount) ...[
                gapH8,
                ValueListenableBuilder(
                  valueListenable: _discounts,
                  builder: (context, discounts, _) {
                    return DiscountsSection(
                      discounts: discounts,
                      discountType: _getDiscountType(),
                      onDiscountsChanged: (discounts) =>
                          _discounts.value = discounts,
                    );
                  },
                ),
              ],
              if (allowIncrement) ...[
                gapH8,
                ValueListenableBuilder(
                  valueListenable: _incrementType,
                  builder: (context, value, _) {
                    return IncrementField(
                      controller: _incrementValueController,
                      type: value,
                      onTypeChanged: (type) => _incrementType.value = type,
                    );
                  },
                ),
              ],
              gapH8,
              ObservationsField(controller: _observationsController),
              gapH32,
              PrimaryButton(text: 'CONFIRMAR'.hardcoded, onPressed: _saveItem),
              gapH8,
            ],
          ),
        ),
      ),
    );
  }

  PercentageOrValue _getDiscountType() {
    final discounts = _editedItem.discounts ?? [];
    if (discounts.isEmpty) return PercentageOrValue.value;

    final firstDiscount = discounts.first.discount;
    return firstDiscount?.type ?? PercentageOrValue.value;
  }
}
