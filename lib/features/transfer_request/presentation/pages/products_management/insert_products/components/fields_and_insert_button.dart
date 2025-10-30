import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../../../core/domain/entities/entities.dart';
import '../../../../../../../core/validators/validators.dart';
import '../../../../../domain/entities/entities.dart';
import '../../../../controllers/controllers.dart';

class FieldsAndInsertButton extends ConsumerWidget {
  final ProductEntity product;
  final TransferRequestProductItemEntity? cartItem;
  final TextEditingController quantityController;
  final TextEditingController priceController;
  final FocusNode quantityFocusNode;
  final FocusNode priceFocusNode;
  final DraftKey draftKey;
  final void Function(int? index) changeSelectedIndex;
  final bool requestTypeAllowChangePrice;

  const FieldsAndInsertButton({
    super.key,
    required this.product,
    required this.cartItem,
    required this.quantityController,
    required this.priceController,
    required this.draftKey,
    required this.changeSelectedIndex,
    required this.quantityFocusNode,
    required this.priceFocusNode,
    required this.requestTypeAllowChangePrice,
  });

  static final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mergedListenable = Listenable.merge([
      quantityController,
      priceController,
    ]);
    void insertProduct() {
      if (formKey.currentState?.validate() != true) {
        return;
      }

      final writtenQuantity = quantityController.text.toDouble() ?? 0;
      final newQuantity = (cartItem?.quantity ?? 0) + writtenQuantity;
      final value = priceController.text.toDouble() ?? product.Value;

      ref
          .read(cartProductsStateControllerProvider(draftKey).notifier)
          .addItem(
            TransferRequestProductItemEntity(
              product: product,
              quantity: newQuantity,
              value: value,
            ),
          );

      changeSelectedIndex(null);
    }

    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return Form(
      key: formKey,
      child: FocusTraversalGroup(
        descendantsAreTraversable: true,
        policy: OrderedTraversalPolicy(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  FocusTraversalOrder(
                    order: NumericFocusOrder(1),
                    child: DefaultTextFormField(
                      controller: quantityController,
                      focusNode: quantityFocusNode,
                      labelText: 'Quantidade'.hardcoded,
                      hintText: 'Quantidade'.hardcoded,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onFieldSubmitted: (_) {
                        if (requestTypeAllowChangePrice) {
                          priceFocusNode.requestFocus();
                        } else {
                          insertProduct();
                        }
                      },
                      maxLength: 13,
                      onTap: () {
                        if (quantityFocusNode.hasFocus) {
                          return;
                        }
                        quantityController.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: quantityController.text.length,
                        );
                      },
                      validator: FormValidators.compose([
                        NonEmptyValidator(),
                        NumberValidator(
                          allowDecimal: true,
                          maxDecimalHouses: 3,
                        ),
                      ]),
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ), //TODO test in iOS
                    ),
                  ),
                  if (requestTypeAllowChangePrice)
                    FocusTraversalOrder(
                      order: NumericFocusOrder(2),
                      child: DefaultTextFormField(
                        controller: priceController,
                        focusNode: priceFocusNode,
                        labelText: 'Novo preço'.hardcoded,
                        hintText: 'Novo preço'.hardcoded,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onFieldSubmitted: (_) => insertProduct(),
                        maxLength: 13,
                        onTap: () {
                          if (priceFocusNode.hasFocus) {
                            return;
                          }
                          priceController.selection = TextSelection(
                            baseOffset: 0,
                            extentOffset: priceController.text.length,
                          );
                        },
                        validator: FormValidators.compose([
                          NonEmptyValidator(),
                          NumberValidator(
                            allowDecimal: true,
                            maxDecimalHouses: 2,
                          ),
                        ]),
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ), //TODO test in iOS
                      ),
                    ),
                ],
              ),
            ),
            gapW8,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: AnimatedBuilder(
                      // Listen to the merged controller
                      animation: mergedListenable,
                      builder: (context, child) {
                        final quantity =
                            quantityController.text.toDouble() ?? 0;
                        final price =
                            priceController.text.toDouble() ?? product.Value;
                        final total = price * quantity;

                        return TitleAndSubTitle(
                          title: 'Total'.hardcoded,
                          subTitle: total.toString().toBrazilianNumber(),
                          subTitleIsPrice: true,
                        );
                      },
                    ),
                  ),
                  PrimaryButton(
                    text: 'Adicionar'.hardcoded,
                    onPressed: () => insertProduct(),
                    icon: Icon(
                      isIOS
                          ? CupertinoIcons.shopping_cart
                          : Icons.shopping_cart,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
