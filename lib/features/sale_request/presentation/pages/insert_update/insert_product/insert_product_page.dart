// lib/features/sale_request/presentation/pages/insert_update/insert_product/insert_product_page.dart
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/sale_request/presentation/pages/insert_update/insert_product/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class InsertProductPage extends ConsumerStatefulWidget {
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
  ConsumerState<InsertProductPage> createState() => _InsertProductPageState();
}

class _InsertProductPageState extends ConsumerState<InsertProductPage> {
  final _quantityFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();
  final _deliveryTaxFocusNode = FocusNode();
  final _discountFocusNode = FocusNode();
  final _incrementFocusNode = FocusNode();

  late final TextEditingController _quantityController;
  late final TextEditingController _priceController;
  late final TextEditingController _deliveryTaxController;
  late final TextEditingController _discountController;
  late final TextEditingController _incrementController;
  final _discountFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    final product = widget.product;

    _quantityController = TextEditingController(
      text: (product.quantity ?? 1).toString().toBrazilianNumber(3, true),
    );

    _priceController = TextEditingController(
      text: (product.value ?? 0).toString().toBrazilianNumber(2),
    );

    final deliveryTax = product.deliveryTax?.value ?? 0;
    _deliveryTaxController = TextEditingController(
      text: deliveryTax <= 0 ? '' : deliveryTax.toString().toBrazilianNumber(),
    );

    final discountValue = product.totalDiscountValue;
    _discountController = TextEditingController(
      text: widget.product.discounts?.length == 1
          ? discountValue.toString().toBrazilianNumber()
          : '',
    );

    final incrementValue = product.increment?.value ?? 0;
    _incrementController = TextEditingController(
      text: incrementValue <= 0
          ? ''
          : incrementValue.toString().toBrazilianNumber(),
    );
  }

  @override
  void dispose() {
    _quantityFocusNode.dispose();
    _priceFocusNode.dispose();
    _deliveryTaxFocusNode.dispose();
    _discountFocusNode.dispose();
    _incrementFocusNode.dispose();

    _quantityController.dispose();
    _priceController.dispose();
    _deliveryTaxController.dispose();
    _discountController.dispose();
    _incrementController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UncontrolledProviderScope(
      container: widget.container,
      child: ProviderScope(
        overrides: [
          currentProductItemProvider.overrideWithValue(widget.product),
        ],
        child: Consumer(
          builder: (_, ref, _) {
            void saveItem() async {
              final uiState = ref.read(
                insertProductUIControllerProvider(widget.product),
              );
              final updatedItem = uiState.applyTo(widget.product);

              final notifier = ref.read(
                insertUpdateStateControllerProvider.notifier,
              );

              final (errorMessage, actions) = notifier.updateItem(
                widget.product,
                updatedItem,
                onlyValidating: true,
              );

              if (errorMessage?.isNotEmpty == true) {
                showToastMessage(errorMessage!, type: ToastType.error);
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

              notifier.updateItem(
                widget.product,
                updatedItem,
                onlyValidating: false,
              );

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
                  s.value?.requestType?.allowUseDiscount == true &&
                      widget.product.saleBlockadeDiscountType ==
                          SaleBlockadeDiscountType.none,
                  s.value?.requestType?.allowUseDeliveryTax == true,
                  s.value?.requestType?.allowUseIncrement == true,
                ),
              ),
            );

            final uiProvider = insertProductUIControllerProvider(
              widget.product,
            );

            ref.listen(uiProvider.select((s) => s.price), (p, n) {
              if (!_priceFocusNode.hasPrimaryFocus) {
                final nextPriceStr = n.toString().toBrazilianNumber(2);
                if (_priceController.text != nextPriceStr) {
                  _priceController.text = nextPriceStr;
                }
              }
            });

            void requestNextFocusFromQuantity() {
              if (allowPriceChange) {
                _priceFocusNode.requestFocus();
              } else if (allowDeliveryTax) {
                _deliveryTaxFocusNode.requestFocus();
              } else if (allowDiscount) {
                _discountFocusNode.requestFocus();
              } else if (allowIncrement) {
                _incrementFocusNode.requestFocus();
              } else {
                _quantityFocusNode.unfocus();
              }
            }

            void requestNextFocusFromPrice() {
              if (allowDeliveryTax) {
                _deliveryTaxFocusNode.requestFocus();
              } else if (allowDiscount) {
                _discountFocusNode.requestFocus();
              } else if (allowIncrement) {
                _incrementFocusNode.requestFocus();
              } else {
                _priceFocusNode.unfocus();
              }
            }

            void requestNextFocusFromDeliveryTax() {
              if (allowDiscount) {
                _discountFocusNode.requestFocus();
              } else if (allowIncrement) {
                _incrementFocusNode.requestFocus();
              } else {
                _deliveryTaxFocusNode.unfocus();
              }
            }

            void requestNextFocusFromDiscount() {
              if (allowIncrement) {
                _incrementFocusNode.requestFocus();
              } else {
                _discountFocusNode.unfocus();
              }
            }

            return BaseScaffold(
              isScrollable: false,
              usePadding: false,
              resizeToAvoidBottomInset: true,
              appBar: BaseAppBar(
                showSelectedEnterprise: false,
                title:
                    widget.product.product?.name ??
                    'Detalhe do Produto'.hardcoded,
              ),
              body: ResponsiveCenter(
                padding: const EdgeInsets.symmetric(horizontal: Sizes.p8),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Hero(
                        tag:
                            widget.heroTag ??
                            'product-${widget.originalProduct.ProductPackingCode}',
                        child: Material(
                          type: MaterialType.transparency,
                          child: SingleChildScrollView(
                            child: ProductItemWidget(
                              product: widget.originalProduct,
                              routine: BsRoutine.saleRequest,
                            ),
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
                              controller: _quantityController,
                              textInputAction:
                                  allowPriceChange ||
                                      allowDeliveryTax ||
                                      allowDiscount ||
                                      allowIncrement
                                  ? TextInputAction.next
                                  : TextInputAction.done,
                              onFieldSubmitted: (_) =>
                                  requestNextFocusFromQuantity(),
                            ),
                          ),
                          gapW8,
                          Expanded(
                            child: PriceField(
                              focusNode: _priceFocusNode,
                              controller: _priceController,
                              allowPriceChange: allowPriceChange,
                              textInputAction:
                                  allowDeliveryTax ||
                                      allowDiscount ||
                                      allowIncrement
                                  ? TextInputAction.next
                                  : TextInputAction.done,
                              onFieldSubmitted: (_) =>
                                  requestNextFocusFromPrice(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (allowDeliveryTax) ...[
                      const SliverToBoxAdapter(child: DefaultDivider()),
                      SliverToBoxAdapter(
                        child: DeliveryTaxField(
                          focusNode: _deliveryTaxFocusNode,
                          controller: _deliveryTaxController,
                          textInputAction: allowDiscount || allowIncrement
                              ? TextInputAction.next
                              : TextInputAction.done,
                          onFieldSubmitted: (_) =>
                              requestNextFocusFromDeliveryTax(),
                        ),
                      ),
                    ],
                    if (allowDiscount) ...[
                      const SliverToBoxAdapter(child: DefaultDivider()),
                      SliverToBoxAdapter(
                        child: AddDiscount(
                          focusNode: _discountFocusNode,
                          controller: _discountController,
                          formKey: _discountFormKey,
                          textInputAction: allowIncrement
                              ? TextInputAction.next
                              : TextInputAction.done,
                          onFieldSubmitted: (_) =>
                              requestNextFocusFromDiscount(),
                        ),
                      ),
                      const Discounts(),
                    ],
                    if (allowIncrement) ...[
                      const SliverToBoxAdapter(child: DefaultDivider()),
                      SliverToBoxAdapter(
                        child: IncrementField(
                          focusNode: _incrementFocusNode,
                          controller: _incrementController,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) =>
                              _incrementFocusNode.unfocus(),
                        ),
                      ),
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
                    gapSliverH48,
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
