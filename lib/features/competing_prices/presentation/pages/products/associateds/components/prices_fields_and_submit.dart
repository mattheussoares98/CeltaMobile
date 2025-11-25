import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../../../core/domain/entities/entities.dart';
import '../../../../../../../core/validators/validators.dart';
import '../../../../../../../localization/string_hardcoded.dart';
import '../../../../../../../utils/utils.dart';
import 'components.dart';

class PricesFieldsAndSubmit extends StatefulWidget {
  final ProductsItems widget;
  final ProductEntity product;
  const PricesFieldsAndSubmit({
    super.key,
    required this.widget,
    required this.product,
  });

  @override
  State<PricesFieldsAndSubmit> createState() => _PricesFieldsAndSubmitState();
}

class _PricesFieldsAndSubmitState extends State<PricesFieldsAndSubmit> {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DefaultRowFields(
            controller: widget.widget.retailController,
            offerController: widget.widget.retailOfferController,
            focusNode: widget.widget.retailFocusNode,
            offerFocusNode: widget.widget.retailOfferFocusNode,
            priceType: 'Venda',
            onSubmit: widget.widget.wholeFocusNode.requestFocus,
          ),
          DefaultRowFields(
            controller: widget.widget.wholeController,
            offerController: widget.widget.wholeOfferController,
            focusNode: widget.widget.wholeFocusNode,
            offerFocusNode: widget.widget.wholeOfferFocusNode,
            priceType: 'Atacado',
            onSubmit: widget.widget.ecommerceFocusNode.requestFocus,
          ),
          DefaultRowFields(
            controller: widget.widget.ecommerceController,
            offerController: widget.widget.ecommerceOfferController,
            focusNode: widget.widget.ecommerceFocusNode,
            offerFocusNode: widget.widget.ecommerceOfferFocusNode,
            priceType: 'Ecommerce',
            onSubmit: () {
              //TODO submit
            },
          ),
          gapH8,
          AnimatedBuilder(
            animation: Listenable.merge([
              widget.widget.retailController,
              widget.widget.retailOfferController,
              widget.widget.wholeController,
              widget.widget.wholeOfferController,
              widget.widget.ecommerceController,
              widget.widget.ecommerceOfferController,
            ]),
            builder: (_, _) {
              bool isValid = false;

              if ((widget.widget.retailController.text.toDouble() ?? 0) !=
                  widget.product.RetailPracticedPrice) {
                isValid = true;
              } else if ((widget.widget.retailOfferController.text.toDouble() ??
                      0) !=
                  widget.product.RetailOfferPrice) {
                isValid = true;
              } else if ((widget.widget.wholeController.text.toDouble() ?? 0) !=
                  widget.product.WholePracticedPrice) {
                isValid = true;
              } else if ((widget.widget.wholeOfferController.text.toDouble() ??
                      0) !=
                  widget.product.WholeOfferPrice) {
                isValid = true;
              } else if ((widget.widget.ecommerceController.text.toDouble() ??
                      0) !=
                  widget.product.ECommercePracticedPrice) {
                isValid = true;
              } else if ((widget.widget.ecommerceOfferController.text
                          .toDouble() ??
                      0) !=
                  widget.product.ECommerceOfferPrice) {
                isValid = true;
              }

              return PrimaryButton(
                text: 'Confirmar alterações'.hardcoded,
                onPressed: isValid
                    ? () {
                        //TODO think in a way to enable click only when change was made
                      }
                    : null,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DefaultDeleteIcon extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  const _DefaultDeleteIcon(this.controller, this.focusNode);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;
    return IconButton(
      focusNode: FocusNode(skipTraversal: true),
      onPressed: () {
        controller.clear();
        if (!focusNode.hasFocus) {
          debugPrint('requested focus');
          focusNode.requestFocus();
        }
      },
      icon: Icon(
        isIOS ? CupertinoIcons.delete : Icons.delete,
        color: Colors.red,
      ),
    );
  }
}

class DefaultRowFields extends StatelessWidget {
  final TextEditingController controller;
  final TextEditingController offerController;
  final FocusNode focusNode;
  final FocusNode offerFocusNode;
  final String priceType;
  final bool? autoFocusFirstField;
  final VoidCallback onSubmit;

  const DefaultRowFields({
    super.key,
    required this.controller,
    required this.offerController,
    required this.focusNode,
    required this.offerFocusNode,
    required this.priceType,
    required this.onSubmit,
    this.autoFocusFirstField = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DefaultTextFormField(
            autofocus: autoFocusFirstField,
            controller: controller,
            focusNode: focusNode,
            labelText: priceType,
            hintText: priceType,
            maxLength: 13,
            suffixIcon: _DefaultDeleteIcon(controller, focusNode),
            onFieldSubmitted: (_) => offerFocusNode.requestFocus(),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: FormValidators.compose([
              NumberValidator(allowDecimal: true, allowEmptyValue: true),
            ]),
          ),
        ),
        gapW4,
        Expanded(
          child: DefaultTextFormField(
            controller: offerController,
            focusNode: offerFocusNode,
            onFieldSubmitted: (_) => onSubmit(),
            labelText: '$priceType (oferta)'.hardcoded,
            hintText: '$priceType (oferta)'.hardcoded,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            maxLength: 13,
            suffixIcon: _DefaultDeleteIcon(offerController, offerFocusNode),
            validator: FormValidators.compose([
              NumberValidator(allowDecimal: true, allowEmptyValue: true),
            ]),
          ),
        ),
      ],
    );
  }
}
