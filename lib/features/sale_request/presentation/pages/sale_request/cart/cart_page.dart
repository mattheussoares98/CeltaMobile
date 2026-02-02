import 'package:celta_inventario/core/presentation/controllers/keyboard/keyboard/keyboard_visibility_state_controller.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../domain/entities/entities.dart';
import '../../../controllers/controllers.dart';
import 'components/components.dart';

class CartPage extends ConsumerStatefulWidget {
  final RequestTypeEntity selectedRequest;
  final int enterpriseCode;
  const CartPage({
    super.key,
    required this.selectedRequest,
    required this.enterpriseCode,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage>
    with WidgetsBindingObserver {
  final quantityController = TextEditingController();
  final observationsController = TextEditingController();
  final instructionsController = TextEditingController();
  final discountController = TextEditingController();
  final priceController = TextEditingController();
  final quantityFocusNode = FocusNode();
  final observationsFocusNode = FocusNode();
  final instructionsFocusNode = FocusNode();
  final discountFocusNode = FocusNode();
  final priceFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    quantityController.dispose();
    observationsController.dispose();
    instructionsController.dispose();
    discountController.dispose();
    priceController.dispose();
    quantityFocusNode.dispose();
    observationsFocusNode.dispose();
    instructionsFocusNode.dispose();
    discountFocusNode.dispose();
    priceFocusNode.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        final value = await ref.read(
          pendingSaleRequestStateControllerProvider(
            widget.enterpriseCode,
          ).future,
        );
        observationsController.text = value.observations ?? '';
        instructionsController.text = value.instructions ?? '';
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      saveInstructionsAndObservations();
    }
  }

  void saveInstructionsAndObservations() async {
    final notifier = ref.read(
      pendingSaleRequestStateControllerProvider(widget.enterpriseCode).notifier,
    );
    await notifier.changeObservations(observationsController.text);
    await notifier.changeInstructions(instructionsController.text);
  }

  void changeSelectedIndex(CartProductEntity product) async {
    ref
        .read(selectedItemUIControllerProvider(isCartPage: true).notifier)
        .selectProduct(product.ProductPackingCode, product);

    if (quantityFocusNode.hasFocus) {
      quantityFocusNode.unfocus();
      await Future.delayed(const Duration(milliseconds: 100));
    } else if (observationsFocusNode.hasFocus) {
      observationsFocusNode.unfocus();
      await Future.delayed(const Duration(milliseconds: 100));
    } else if (instructionsFocusNode.hasFocus) {
      instructionsFocusNode.unfocus();
      await Future.delayed(const Duration(milliseconds: 100));
    }

    final selectedPackingCode = ref.read(
      selectedItemUIControllerProvider(
        isCartPage: true,
      ).select((s) => s.productPackingCode),
    );

    if (selectedPackingCode == null) {
      return;
    }

    priceController.clear();
    discountController.clear();

    quantityController.text = product.Quantity.toString()
        .toBrazilianNumber(3, true)
        .replaceAll(RegExp(r'\.'), '');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      quantityFocusNode.requestFocus();
      quantityController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: quantityController.text.length,
      );
    });
  }

  void calculatePrices() {
    ref
        .read(processCartControllerProvider.notifier)
        .process(
          enterpriseCode: widget.enterpriseCode,
          requestTypeCode: widget.selectedRequest.Code,
        );
  }

  void saveSaleRequest() {
    ref
        .read(saveSaleRequestControllerProvider.notifier)
        .save(
          enterpriseCode: widget.enterpriseCode,
          requestTypeCode: widget.selectedRequest.Code,
          instructions: instructionsController.text,
          observations: observationsController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(processCartControllerProvider, (p, n) {
      n.showAlertDialogOnError(context);
    });

    ref.listen(saveSaleRequestControllerProvider, (p, n) {
      n.showAlertDialogOnError(context);
      n.doOnSuccess(p, () {
        instructionsController.clear();
        observationsController.clear();
      });
    });

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        saveInstructionsAndObservations();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.p8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Consumer(
              builder: (_, ref, _) {
                final cartProducts = ref.watch(
                  pendingSaleRequestStateControllerProvider(
                    widget.enterpriseCode,
                  ).select(
                    (state) => (state.value?.cart ?? const {}).values.toList(),
                  ),
                );

                if (cartProducts.isEmpty) {
                  return const Expanded(child: InsertProductsInCart());
                }

                return Expanded(
                  child: CustomScrollView(
                    physics: const ClampingScrollPhysics(),
                    slivers: [
                      ObservationsField(
                        observationsFocusNode: observationsFocusNode,
                        observationsController: observationsController,
                        instructionsFocusNode: instructionsFocusNode,
                      ),
                      gapSliverH4,
                      InstructionsField(
                        instructionsFocusNode: instructionsFocusNode,
                        instructionsController: instructionsController,
                      ),
                      gapSliverH8,

                      ResponsiveListFlow(
                        isSliver: true,
                        itemCount: cartProducts.length,
                        itemBuilder: (_, index) {
                          final cartProduct = cartProducts[index];

                          return ProductItem(
                            key: ValueKey(
                              '${cartProduct.ProductPackingCode}${cartProduct.product?.EnterpriseCode}',
                            ),
                            enterpriseCode: widget.enterpriseCode,
                            cartProduct: cartProduct,
                            onTap: () => changeSelectedIndex(cartProduct),
                            quantityController: quantityController,
                            priceController: priceController,
                            discountController: discountController,
                            quantityFocusNode: quantityFocusNode,
                            discountFocusNode: discountFocusNode,
                            priceFocusNode: priceFocusNode,
                            selectedRequest: widget.selectedRequest,
                          );
                        },
                      ),
                      Consumer(
                        builder: (_, ref, _) {
                          final keyboardIsOpen = ref.watch(
                            keyboardVisibilityStateControllerProvider,
                          );
                          if (!keyboardIsOpen) {
                            return const SliverToBoxAdapter(
                              child: SizedBox.shrink(),
                            );
                          }

                          return AnimatedBuilder(
                            animation: Listenable.merge([
                              quantityFocusNode,
                              priceFocusNode,
                              discountFocusNode,
                            ]),
                            builder: (_, _) {
                              return SliverToBoxAdapter(
                                child: TotalCalculateAndSave(
                                  enterpriseCode: widget.enterpriseCode,
                                  saveSaleRequest: saveSaleRequest,
                                  calculatePrices: calculatePrices,
                                ),
                              );
                            },
                          );
                        },
                      ),
                      gapSliverH48,
                    ],
                  ),
                );
              },
            ),
            Consumer(
              builder: (_, ref, _) {
                final keyboardIsOpen = ref.watch(
                  keyboardVisibilityStateControllerProvider,
                );

                if (keyboardIsOpen) {
                  //TODO fix when tap the button after close the keyboard
                  return const SizedBox.shrink();
                }

                return TotalCalculateAndSave(
                  enterpriseCode: widget.enterpriseCode,
                  saveSaleRequest: saveSaleRequest,
                  calculatePrices: calculatePrices,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
