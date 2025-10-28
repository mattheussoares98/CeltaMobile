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

class FieldsAndInsertButton extends ConsumerStatefulWidget {
  final TextEditingController quantityController;
  final TextEditingController priceController;
  final FocusNode quantityFocusNode;
  final FocusNode priceFocusNode;
  final ProductEntity product;
  final int requestTypeCode;
  final int enterpriseOriginCode;
  final int enterpriseDestinyCode;
  final bool requestTypeAllowChangePrice;

  const FieldsAndInsertButton({
    super.key,
    required this.quantityController,
    required this.priceController,
    required this.quantityFocusNode,
    required this.priceFocusNode,
    required this.product,
    required this.requestTypeCode,
    required this.enterpriseOriginCode,
    required this.enterpriseDestinyCode,
    required this.requestTypeAllowChangePrice,
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
      widget.quantityController,
      widget.priceController,
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
          pendingTransferRequestStateControllerProvider(
            DraftKey(
              requestTypeCode: widget.requestTypeCode,
              enterpriseOrigin: widget.enterpriseOriginCode,
              enterpriseDestinyCode: widget.enterpriseDestinyCode,
            ),
          ).notifier,
        )
        .addItem(
          TransferRequestProductItemEntity(
            product: widget.product,
            quantity: widget.quantityController.text.toDouble() ?? 0,
            value:
                widget.priceController.text.toDouble() ?? widget.product.Value,
          ),
        );

    widget.quantityController.text = '1';
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
                      controller: widget.quantityController,
                      focusNode: widget.quantityFocusNode,
                      labelText: 'Quantidade'.hardcoded,
                      hintText: 'Quantidade'.hardcoded,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onFieldSubmitted: (_) {
                        if (widget.requestTypeAllowChangePrice) {
                          widget.priceFocusNode.requestFocus();
                        } else {
                          insertProduct();
                        }
                      },
                      maxLength: 13,
                      onTap: () {
                        if (widget.quantityFocusNode.hasFocus) {
                          return;
                        }
                        widget.quantityController.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: widget.quantityController.text.length,
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
                  if (widget.requestTypeAllowChangePrice)
                    FocusTraversalOrder(
                      order: NumericFocusOrder(2),
                      child: DefaultTextFormField(
                        controller: widget.priceController,
                        focusNode: widget.priceFocusNode,
                        labelText: 'Novo preço'.hardcoded,
                        hintText: 'Novo preço'.hardcoded,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onFieldSubmitted: (_) => insertProduct(),
                        maxLength: 13,
                        onTap: () {
                          if (widget.priceFocusNode.hasFocus) {
                            return;
                          }
                          widget.priceController.selection = TextSelection(
                            baseOffset: 0,
                            extentOffset: widget.priceController.text.length,
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
                            widget.quantityController.text.toDouble() ?? 0;
                        final price =
                            widget.priceController.text.toDouble() ??
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
