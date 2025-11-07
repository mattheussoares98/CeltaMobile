import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
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
  const CartPage({super.key, required this.selectedRequest});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
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

    observationsFocusNode.removeListener(_onObservationsFocusChange);
    instructionsFocusNode.removeListener(_onInstructionsFocusChange);
  }

  @override
  void initState() {
    super.initState();

    observationsFocusNode.addListener(_onObservationsFocusChange);
    instructionsFocusNode.addListener(_onInstructionsFocusChange);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        final value = await ref.read(
          pendingSaleRequestStateControllerProvider.future,
        );
        observationsController.text = value.observations ?? '';
        instructionsController.text = value.instructions ?? '';
      }
    });
  }

  void _onObservationsFocusChange() {
    if (!observationsFocusNode.hasFocus) {
      ref
          .read(pendingSaleRequestStateControllerProvider.notifier)
          .changeObservations(observationsController.text);
    }
  }

  void _onInstructionsFocusChange() {
    if (!instructionsFocusNode.hasFocus) {
      ref
          .read(pendingSaleRequestStateControllerProvider.notifier)
          .changeInstructions(instructionsController.text);
    }
  }

  void changeSelectedIndex(int? index, CartProductEntity product) {
    ref
        .read(selectedItemUIControllerProvider(isCartPage: true).notifier)
        .selectProduct(product.ProductPackingCode, product);

    final selectedPackingCode = ref
        .read(selectedItemUIControllerProvider(isCartPage: true))
        .productPackingCode;

    if (selectedPackingCode == null) {
      return;
    }

    quantityController.text = product.Quantity.toString()
        .toBrazilianNumber(3, true)
        .replaceAll(RegExp(r'\.'), '');
    priceController.text = product.Value.toString()
        .toBrazilianNumber(2, true)
        .replaceAll(RegExp(r'\.'), '');
    if ((product.DiscountValue ?? 0) > 0) {
      discountController.text = product.getValueOrPercentageDiscount
          .toString()
          .toBrazilianNumber()
          .replaceAll(RegExp(r'\.'), '');
    } else {
      discountController.clear();
    }

    Future.delayed(const Duration(milliseconds: 100), () {
      quantityFocusNode.requestFocus();
      quantityController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: quantityController.text.length,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProducts = ref.watch(
      pendingSaleRequestStateControllerProvider.select(
        (state) => state.value?.cart.values.toList() ?? [],
      ),
    );

    ref.listen(processCartControllerProvider, (p, n) {
      n.showSnackbarOnError(context, p);
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.p8),
      child: Column(
        children: [
          ObservationsField(
            observationsFocusNode: observationsFocusNode,
            observationsController: observationsController,
            instructionsFocusNode: instructionsFocusNode,
          ),
          gapH4,
          InstructionsField(
            instructionsFocusNode: instructionsFocusNode,
            instructionsController: instructionsController,
          ),
          gapH8,
          Expanded(
            child: ResponsiveListFlow(
              itemCount: cartProducts.length,
              itemBuilder: (_, index) {
                final cartProduct = cartProducts[index];

                if (cartProducts.isEmpty) {
                  return Center(
                    child: Text('Nenhum item no carrinho'.hardcoded),
                  );
                }

                return ProductItem(
                  cartProduct: cartProduct,
                  onTap: () => changeSelectedIndex(index, cartProduct),
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
          ),
          Padding(
            padding: const EdgeInsets.all(Sizes.p8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  flex: 3,
                  child: Column(children: [Text('Total'), Text('x')]),
                ),
                Expanded(
                  flex: 7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      PrimaryButton(
                        text: 'Calcular preços'.hardcoded,
                        onPressed: () {
                          //TODO show this only if the user has permission to change the prices, or has any manual price
                          showAlertDialog(
                            context: context,
                            title: 'Calcular preços?'.hardcoded,
                            cancelActionText: 'Cancelar'.hardcoded,
                            content:
                                'Ao calcular os preços, serão obtidos os preços calculados pelo BS de acordo com promoções, negociações de vendas, oferta, atacado de acordo com a quantidade mínima, etc'
                                    .hardcoded,
                            onOkPressed: () {
                              ref
                                  .read(processCartControllerProvider.notifier)
                                  .process(
                                    requestTypeCode:
                                        widget.selectedRequest.Code,
                                  );
                            },
                          );
                        },
                      ),
                      gapH4,
                      PrimaryButton(text: 'Salvar pedido'.hardcoded),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
