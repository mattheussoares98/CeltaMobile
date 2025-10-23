import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/products/products.dart';
import '../../../../../core/validators/validators.dart';
import '../../../../enterprise_manager/domain/entities/entities.dart';
import '../../../../enterprises/presentation/controllers/controllers.dart';
import '../../../domain/entities/entities.dart';
import '../../controllers/controllers.dart';

class ProductsPage extends ConsumerStatefulWidget {
  final TextEditingController searchProductController;
  final TextEditingController quantityController;
  final TextEditingController costController;
  final FocusNode quantityFocusNode;
  final FocusNode costFocusNode;
  const ProductsPage({
    super.key,
    required this.searchProductController,
    required this.quantityController,
    required this.costController,
    required this.quantityFocusNode,
    required this.costFocusNode,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductsPageState();
}

class _ProductsPageState extends ConsumerState<ProductsPage> {
  int? selectedIndex;
  final fieldsFormKey = GlobalKey<FormState>();
  final quantityFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    fieldsFormKey.currentState?.dispose();
    quantityFormKey.currentState?.dispose();
    super.dispose();
  }

  void insertProduct(
    AsyncValue<PendingBuyRequestEntity> pendingAsync,
    ProductEntity product,
  ) {
    if (fieldsFormKey.currentState?.validate() != true) {
      widget.costFocusNode.requestFocus();
      return;
    }
    final products = pendingAsync.value?.products;
    products?.addAll({
      ProductKey(
        enterpriseCode: product.EnterpriseCode,
        productPackingCode: product.ProductPackingCode,
      ): BuyRequestProductItemEntity(
        product: product,
        quantity: widget.quantityController.text.toDouble()!,
        cost: widget.costController.text.toDouble()!,
      ),
    });
    ref
        .read(pendingBuyRequestStateControllerProvider.notifier)
        .updatePending(pendingAsync.value!.copyWith(products: products));
    widget.quantityController.clear();
    widget.costController.clear();
    setState(() {
      selectedIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedEnterprise = ref.watch(
      selectedEnterpriseStateControllerProvider,
    );

    ref.listen(
      searchProductsStateControllerProvider(
        selectedEnterprise?.Code ?? 0,
        BsRoutine.buyRequest,
        Modules.buyRequest,
      ),
      (products, next) {
        next.doOnSuccess(products, () {
          widget.searchProductController.clear();
        });
      },
    );

    final productsState = ref.watch(
      searchProductsStateControllerProvider(
        selectedEnterprise?.Code ?? 0,
        BsRoutine.buyRequest,
        Modules.buyRequest,
      ),
    );

    final pendingAsync = ref.watch(pendingBuyRequestStateControllerProvider);

    Future<void> searchProducts() async {
      await ref
          .read(
            searchProductsStateControllerProvider(
              selectedEnterprise?.Code ?? 0,
              BsRoutine.buyRequest,
              Modules.buyRequest,
            ).notifier,
          )
          .loadProducts(
            enterpriseCodes:
                pendingAsync.value?.selectedEnterprises
                    ?.map((e) => e.Code!)
                    .toList() ??
                [],
            searchValue: widget.searchProductController.text,
          );
    }

    final theme = Theme.of(context);

    void onTap(int index) {
      if (selectedIndex != index) {
        setState(() {
          selectedIndex = index;
        });
        Future.delayed(Duration(milliseconds: 100), () {
          widget.quantityFocusNode.requestFocus();
        });
      } else {
        setState(() {
          selectedIndex = null;
        });
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text('Produtos'.hardcoded)),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: DefaultSearchProducts(
                isLoading: productsState.isLoading,
                searchProducts: searchProducts,
                searchValueController: widget.searchProductController,
              ),
            ),
            gapSliverH8,
            AsyncValueSliverWidget(
              value: productsState,
              tryAgain: null,
              data: (products) {
                return SliverList.builder(
                  itemCount: products.length,
                  itemBuilder: (_, index) {
                    final product = products[index];

                    final correspondentEnterprise = pendingAsync
                        .value
                        ?.selectedEnterprises
                        ?.firstWhere((e) => e.Code == product.EnterpriseCode);

                    return ProductItemWidget(
                      onTap: () => onTap(index),
                      product: product,
                      routine: BsRoutine.buyRequest,
                      showDropIcon: true,
                      isSelected: selectedIndex == index,
                      onDelete:
                          pendingAsync.value?.products?.containsKey(
                                ProductKey(
                                  enterpriseCode: product.EnterpriseCode,
                                  productPackingCode:
                                      product.ProductPackingCode,
                                ),
                              ) ??
                              false
                          ? () {
                              final products = pendingAsync.value?.products;
                              products?.removeWhere((key, value) {
                                return key ==
                                    ProductKey(
                                      enterpriseCode: product.EnterpriseCode,
                                      productPackingCode:
                                          product.ProductPackingCode,
                                    );
                              });

                              ref
                                  .read(
                                    pendingBuyRequestStateControllerProvider
                                        .notifier,
                                  )
                                  .updatePending(
                                    pendingAsync.value!.copyWith(
                                      products: products,
                                    ),
                                  );
                            }
                          : null,
                      itemBeforeProductName: TitleAndSubTitle(
                        title: null,
                        subTitle:
                            '(${correspondentEnterprise?.PersonalizedCode}) - ${correspondentEnterprise?.name}',
                        subTitleStyle: theme.textTheme.titleMedium?.copyWith(
                          color: theme.primaryColor,
                        ),
                      ),
                      notClickableBottom: selectedIndex == index
                          ? Form(
                              key: fieldsFormKey,
                              child: Padding(
                                padding: const EdgeInsets.only(top: Sizes.p8),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Form(
                                        key: quantityFormKey,
                                        child: DefaultTextFormField(
                                          focusNode: widget.quantityFocusNode,
                                          controller: widget.quantityController,
                                          labelText: 'Quantidade'.hardcoded,
                                          hintText: 'Quantidade'.hardcoded,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          keyboardType:
                                              TextInputType.numberWithOptions(
                                                decimal: true,
                                                //TODO test in iOS
                                              ),
                                          validator: FormValidators.compose([
                                            NonEmptyValidator(),
                                            NumberValidator(
                                              allowDecimal: true,
                                              maxDecimalHouses: 3,
                                            ),
                                          ]),
                                          maxLength: 13,
                                          onFieldSubmitted: (_) {
                                            if (quantityFormKey.currentState
                                                    ?.validate() !=
                                                true) {
                                              widget.quantityFocusNode
                                                  .requestFocus();
                                            } else {
                                              widget.costFocusNode
                                                  .requestFocus();
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    gapW8,
                                    Expanded(
                                      child: DefaultTextFormField(
                                        focusNode: widget.costFocusNode,
                                        controller: widget.costController,
                                        labelText: 'Custo'.hardcoded,
                                        hintText: 'Custo'.hardcoded,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                              decimal: true,
                                              //TODO test in iOS
                                            ),
                                        validator: FormValidators.compose([
                                          NonEmptyValidator(),
                                          NumberValidator(
                                            allowDecimal: true,
                                            maxDecimalHouses: 4,
                                          ),
                                        ]),
                                        maxLength: 13,
                                        onFieldSubmitted: (_) {
                                          insertProduct(pendingAsync, product);
                                        },
                                      ),
                                    ),
                                    gapW8,
                                    Expanded(
                                      child: PrimaryButton(
                                        text: 'Confirmar'.hardcoded,
                                        onPressed: () {
                                          insertProduct(pendingAsync, product);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : null,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
