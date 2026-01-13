import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../domain/entities/entities.dart';
import '../../controllers/controllers.dart';
import '../components/components.dart';
import '../enterprises/components/components.dart';
import '../identification/components/components.dart';
import 'components/components.dart';

class ConfirmationPage extends ConsumerStatefulWidget {
  const ConfirmationPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ConfirmationPageState();
}

class _ConfirmationPageState extends ConsumerState<ConfirmationPage> {
  final observationsController = TextEditingController();
  final fieldsFormKey = GlobalKey<FormState>();
  final quantityFormKey = GlobalKey<FormState>();
  final quantityController = TextEditingController();
  final costController = TextEditingController();
  final quantityFocusNode = FocusNode();
  final costFocusNode = FocusNode();

  @override
  void dispose() {
    observationsController.dispose();
    quantityController.dispose();
    costController.dispose();
    quantityFocusNode.dispose();
    costFocusNode.dispose();
    super.dispose();
  }

  void onDelete(ProductEntity product, PendingBuyRequestEntity? pending) {
    final products = pending?.products;
    products?.removeWhere((key, value) {
      return key ==
          ProductKey(
            enterpriseCode: product.EnterpriseCode!,
            productPackingCode: product.ProductPackingCode!,
          );
    });

    ref
        .read(pendingBuyRequestStateControllerProvider.notifier)
        .updatePending(pending!.copyWith(products: products));
  }

  @override
  Widget build(BuildContext context) {
    final pendingAsync = ref.watch(pendingBuyRequestStateControllerProvider);
    ref.listen(insertBuyRequestControllerProvider, (p, n) {
      n.showAlertDialogOnError(context);
    });

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                physics: const ClampingScrollPhysics(),
                slivers: [
                  CleanAllDataButton(
                    observationsController: observationsController,
                  ),
                  if (pendingAsync.value?.lastSavedRequestNumber != null) ...[
                    const LastSavedRequestsNumbers(),
                    gapSliverH8,
                  ],
                  SliverToBoxAdapter(
                    child: DefaultTextFormField(
                      controller: observationsController,
                      hintText: 'Observações'.hardcoded,
                      labelText: 'Observações'.hardcoded,
                      maxLines: 4,
                    ),
                  ),
                  gapSliverH8,
                  const BuyersDropdown(),
                  gapSliverH8,
                  const RequestTypeDropdown(),
                  gapSliverH8,
                  if (pendingAsync.value?.selectedSupplier != null) ...[
                    SliverToBoxAdapter(
                      child: DefaultSmallTitle(title: 'Fornecedor'.hardcoded),
                    ),
                    SliverToBoxAdapter(
                      child: SupplierItem(
                        supplier: pendingAsync.value!.selectedSupplier!,
                        pending: pendingAsync.value,
                        enabled: false,
                      ),
                    ),
                    gapSliverH8,
                  ] else
                    UnselectedMessage(
                      title: 'Nenhum fornecedor selecionado'.hardcoded,
                    ),
                  if ((pendingAsync.value?.selectedEnterprises?.length ?? 0) >
                      0) ...[
                    SliverToBoxAdapter(
                      child: DefaultSmallTitle(
                        title:
                            'Empresas (${pendingAsync.value!.selectedEnterprises!.length})'
                                .hardcoded,
                      ),
                    ),
                    SliverList.builder(
                      itemCount:
                          pendingAsync.value?.selectedEnterprises?.length ?? 0,
                      itemBuilder: (_, index) {
                        final enterprise =
                            pendingAsync.value?.selectedEnterprises?[index];

                        return EnterpriseItem(
                          enterprise: enterprise!,
                          enabled: false,
                        );
                      },
                    ),
                    gapSliverH8,
                  ] else
                    UnselectedMessage(
                      title: 'Nenhuma empresa selecionada'.hardcoded,
                    ),
                  if (pendingAsync.value?.products != null &&
                      pendingAsync.value!.products!.isNotEmpty) ...[
                    SliverToBoxAdapter(
                      child: DefaultSmallTitle(
                        title:
                            'Produtos (${pendingAsync.value!.products!.length})'
                                .hardcoded,
                      ),
                    ),
                    gapSliverH8,

                    SliverList.builder(
                      itemCount: pendingAsync.value?.products?.length ?? 0,
                      itemBuilder: (_, index) {
                        final product = pendingAsync.value?.products?.values
                            .toList()[index];
                        return ProductItemWidget(
                          product: product!.product,
                          routine: BsRoutine.buyRequest,
                          hideCost: true,
                          hideCurrentAndSaleStocks: true,
                          hideWholeInformations: true,
                          showDropIcon: true,
                          showInfoButton: false,
                          isSelected: ref.watch(
                            uiStateControllerProvider.select(
                              (s) => s.value?.selectedCartProductIndex == index,
                            ),
                          ),
                          onTap: () {
                            quantityFocusNode.requestFocus();
                            costController.text = product.cost
                                .toString()
                                .toBrazilianNumber(4)
                                .replaceAll(RegExp(r'\.'), '');
                            quantityController.text = product.quantity
                                .toString()
                                .toBrazilianNumber(3, true)
                                .replaceAll(RegExp(r'\.'), '');
                            quantityController.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: quantityController.text.length,
                            );
                            ref
                                .read(uiStateControllerProvider.notifier)
                                .updateSelectedCartProductIndex(index);
                          },
                          cartItemSummary: CartItemSummary(
                            cartQuantity: product.quantity,
                            cartValue: product.cost,
                            product: product.product,
                          ),
                          onDelete: () =>
                              onDelete(product.product, pendingAsync.value),
                          itemBeforeProductName: EnterpriseCodeAndProductName(
                            product: product.product,
                          ),
                          notClickableBottom:
                              ref.watch(
                                uiStateControllerProvider.select(
                                  (s) =>
                                      s.value?.selectedCartProductIndex ==
                                      index,
                                ),
                              )
                              ? FieldsAndConfirm(
                                  isConfirmationPage: true,
                                  fieldsFormKey: fieldsFormKey,
                                  quantityFormKey: quantityFormKey,
                                  quantityController: quantityController,
                                  costController: costController,
                                  quantityFocusNode: quantityFocusNode,
                                  costFocusNode: costFocusNode,
                                  product: product.product,
                                )
                              : null,
                        );
                      },
                    ),
                  ] else
                    UnselectedMessage(
                      title: 'Nenhum produto informado'.hardcoded,
                    ),
                ],
              ),
            ),
            Footer(observationsController: observationsController),
          ],
        ),
      ),
    );
  }
}
