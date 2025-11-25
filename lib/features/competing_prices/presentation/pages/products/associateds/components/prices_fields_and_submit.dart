import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../../../core/domain/entities/entities.dart';
import '../../../../../../../localization/string_hardcoded.dart';
import '../../../../../../../utils/utils.dart';
import '../../../../controllers/controllers.dart';
import 'components.dart';

class PricesFieldsAndSubmit extends ConsumerStatefulWidget {
  final ProductsItems widget;
  final ProductEntity product;
  const PricesFieldsAndSubmit({
    super.key,
    required this.widget,
    required this.product,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PricesFieldsAndSubmitState();
}

class _PricesFieldsAndSubmitState extends ConsumerState<PricesFieldsAndSubmit> {
  final formKey = GlobalKey<FormState>();

  void insertUpdate() async {
    if (formKey.currentState?.validate() != true) {
      return;
    }

    showAlertDialog(
      context: context,
      title: 'Salvar alterações?'.hardcoded,
      defaultActionText: 'Sim'.hardcoded,
      cancelActionText: 'Cancelar'.hardcoded,
      onOkPressed: () {
        ref
            .read(updatePricesControllerProvider.notifier)
            .insertUpdate(
              enterpriseCode: widget.widget.enterpriseCode,
              researchCode: widget.widget.researchCode,
              concurrentCode: widget.widget.concurrentCode,
              productPackingCode: widget.product.ProductPackingCode!,
              priceLookUp: widget.product.PLU!,
              priceRetail: widget.widget.retailController.text.toDouble(),
              offerRetail: widget.widget.retailOfferController.text.toDouble(),
              priceWhole: widget.widget.wholeController.text.toDouble(),
              offerWhole: widget.widget.wholeOfferController.text.toDouble(),
              priceECommerce: widget.widget.ecommerceController.text.toDouble(),
              offerECommerce: widget.widget.ecommerceOfferController.text
                  .toDouble(),
            );
      },
    );
  }

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
            onSubmit: insertUpdate,
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
                onPressed: isValid ? insertUpdate : null,
              );
            },
          ),
        ],
      ),
    );
  }
}
