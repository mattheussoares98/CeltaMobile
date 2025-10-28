import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../core/validators/validators.dart';
import '../../../../domain/entities/entities.dart';
import '../../../controllers/controllers.dart';
import '../../pages.dart';

class FieldsAndInsertButton extends ConsumerStatefulWidget {
  final InsertProductsPage insertProductsPage;
  final ProductEntity product;

  const FieldsAndInsertButton({
    super.key,
    required this.product,
    required this.insertProductsPage,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _QuantityFieldAndInsertButtonState();
}

class _QuantityFieldAndInsertButtonState
    extends ConsumerState<FieldsAndInsertButton> {
  final formKey = GlobalKey<FormState>();
  late final Listenable _mergedListenable;

  @override
  void initState() {
    super.initState();
    _mergedListenable = Listenable.merge([
      widget.insertProductsPage.quantityController,
      widget.insertProductsPage.priceController,
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    formKey.currentState?.dispose();
  }

  void insertProduct() {
    if (formKey.currentState?.validate() != true) {
      return;
    }

    ref
        .read(
          cartProductsStateControllerProvider(
            DraftKey(
              requestTypeCode: widget.insertProductsPage.requestTypeCode,
              enterpriseOrigin: widget.insertProductsPage.enterpriseOriginCode,
              enterpriseDestinyCode:
                  widget.insertProductsPage.enterpriseDestinyCode,
            ),
          ).notifier,
        )
        .addItem(
          TransferRequestProductItemEntity(
            product: widget.product,
            quantity:
                widget.insertProductsPage.quantityController.text.toDouble() ??
                0,
            value:
                widget.insertProductsPage.priceController.text.toDouble() ??
                widget.product.Value,
          ),
        );

    widget.insertProductsPage.changeSelectedIndex(null);
  }

  @override
  Widget build(BuildContext context) {
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
                      controller: widget.insertProductsPage.quantityController,
                      focusNode: widget.insertProductsPage.quantityFocusNode,
                      labelText: 'Quantidade'.hardcoded,
                      hintText: 'Quantidade'.hardcoded,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onFieldSubmitted: (_) {
                        if (widget
                            .insertProductsPage
                            .requestTypeAllowChangePrice) {
                          widget.insertProductsPage.priceFocusNode
                              .requestFocus();
                        } else {
                          insertProduct();
                        }
                      },
                      maxLength: 13,
                      onTap: () {
                        if (widget
                            .insertProductsPage
                            .quantityFocusNode
                            .hasFocus) {
                          return;
                        }
                        widget.insertProductsPage.quantityController.selection =
                            TextSelection(
                              baseOffset: 0,
                              extentOffset: widget
                                  .insertProductsPage
                                  .quantityController
                                  .text
                                  .length,
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
                  if (widget.insertProductsPage.requestTypeAllowChangePrice)
                    FocusTraversalOrder(
                      order: NumericFocusOrder(2),
                      child: DefaultTextFormField(
                        controller: widget.insertProductsPage.priceController,
                        focusNode: widget.insertProductsPage.priceFocusNode,
                        labelText: 'Novo preço'.hardcoded,
                        hintText: 'Novo preço'.hardcoded,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onFieldSubmitted: (_) => insertProduct(),
                        maxLength: 13,
                        onTap: () {
                          if (widget
                              .insertProductsPage
                              .priceFocusNode
                              .hasFocus) {
                            return;
                          }
                          widget.insertProductsPage.priceController.selection =
                              TextSelection(
                                baseOffset: 0,
                                extentOffset: widget
                                    .insertProductsPage
                                    .priceController
                                    .text
                                    .length,
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
                      animation: _mergedListenable,
                      builder: (context, child) {
                        final quantity =
                            widget.insertProductsPage.quantityController.text
                                .toDouble() ??
                            0;
                        final price =
                            widget.insertProductsPage.priceController.text
                                .toDouble() ??
                            widget.product.Value;
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
