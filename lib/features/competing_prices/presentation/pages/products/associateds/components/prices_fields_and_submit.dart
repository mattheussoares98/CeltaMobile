import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../../../core/validators/validators.dart';
import '../../../../../../../localization/string_hardcoded.dart';
import 'components.dart';

class PricesFieldsAndSubmit extends StatefulWidget {
  final ProductsItems widget;
  const PricesFieldsAndSubmit({super.key, required this.widget});

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
          PrimaryButton(
            text: 'Confirmar alterações'.hardcoded,
            onPressed: () {
              //TODO think in a way to enable click only when change was made
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
            suffixIcon: _DefaultDeleteIcon(controller, focusNode),
            onFieldSubmitted: (_) => offerFocusNode.requestFocus(),
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
