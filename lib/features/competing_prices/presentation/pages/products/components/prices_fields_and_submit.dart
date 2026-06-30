import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/competing_prices/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/competing_prices/presentation/pages/products/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PricesFieldsAndSubmit extends ConsumerStatefulWidget {
  final ProductEntity product;
  final TextEditingController retailController;
  final TextEditingController retailOfferController;
  final TextEditingController wholeController;
  final TextEditingController wholeOfferController;
  final TextEditingController ecommerceController;
  final TextEditingController ecommerceOfferController;
  final FocusNode retailFocusNode;
  final FocusNode retailOfferFocusNode;
  final FocusNode wholeFocusNode;
  final FocusNode wholeOfferFocusNode;
  final FocusNode ecommerceFocusNode;
  final FocusNode ecommerceOfferFocusNode;
  final int enterpriseCode;
  final int researchCode;
  final int concurrentCode;
  const PricesFieldsAndSubmit({
    super.key,
    required this.product,
    required this.retailController,
    required this.retailOfferController,
    required this.wholeController,
    required this.wholeOfferController,
    required this.ecommerceController,
    required this.ecommerceOfferController,
    required this.retailFocusNode,
    required this.retailOfferFocusNode,
    required this.wholeFocusNode,
    required this.wholeOfferFocusNode,
    required this.ecommerceFocusNode,
    required this.ecommerceOfferFocusNode,
    required this.enterpriseCode,
    required this.researchCode,
    required this.concurrentCode,
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

    FocusScope.of(context).unfocus();
    FocusManager.instance.primaryFocus?.unfocus();

    showAlertDialog(
      context: context,
      title: 'Salvar alterações?'.hardcoded,
      defaultActionText: 'Sim'.hardcoded,
      cancelActionText: 'Cancelar'.hardcoded,
      onOkPressed: () {
        ref
            .read(updatePricesControllerProvider.notifier)
            .insertUpdate(
              enterpriseCode: widget.enterpriseCode,
              researchCode: widget.researchCode,
              concurrentCode: widget.concurrentCode,
              priceRetail: widget.retailController.text.toDouble() ?? 0,
              offerRetail: widget.retailOfferController.text.toDouble() ?? 0,
              priceWhole: widget.wholeController.text.toDouble() ?? 0,
              offerWhole: widget.wholeOfferController.text.toDouble() ?? 0,
              priceECommerce: widget.ecommerceController.text.toDouble() ?? 0,
              offerECommerce:
                  widget.ecommerceOfferController.text.toDouble() ?? 0,
              product: widget.product,
            );
      },
    );
  }

  bool get hasChangedAnyValue {
    if ((widget.retailController.text.toDouble() ?? 0) !=
        (widget.product.RetailPracticedPrice ?? 0)) {
      return true;
    } else if ((widget.retailOfferController.text.toDouble() ?? 0) !=
        (widget.product.RetailOfferPrice ?? 0)) {
      return true;
    } else if ((widget.wholeController.text.toDouble() ?? 0) !=
        (widget.product.WholePracticedPrice ?? 0)) {
      return true;
    } else if ((widget.wholeOfferController.text.toDouble() ?? 0) !=
        (widget.product.WholeOfferPrice ?? 0)) {
      return true;
    } else if ((widget.ecommerceController.text.toDouble() ?? 0) !=
        (widget.product.ECommercePracticedPrice ?? 0)) {
      return true;
    } else if ((widget.ecommerceOfferController.text.toDouble() ?? 0) !=
        (widget.product.ECommerceOfferPrice ?? 0)) {
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DefaultRowFields(
            controller: widget.retailController,
            offerController: widget.retailOfferController,
            focusNode: widget.retailFocusNode,
            offerFocusNode: widget.retailOfferFocusNode,
            priceType: 'Venda',
            onSubmit: widget.wholeFocusNode.requestFocus,
          ),
          DefaultRowFields(
            controller: widget.wholeController,
            offerController: widget.wholeOfferController,
            focusNode: widget.wholeFocusNode,
            offerFocusNode: widget.wholeOfferFocusNode,
            priceType: 'Atacado',
            onSubmit: widget.ecommerceFocusNode.requestFocus,
          ),
          DefaultRowFields(
            controller: widget.ecommerceController,
            offerController: widget.ecommerceOfferController,
            focusNode: widget.ecommerceFocusNode,
            offerFocusNode: widget.ecommerceOfferFocusNode,
            priceType: 'Ecommerce',
            onSubmit: hasChangedAnyValue ? insertUpdate : null,
          ),
          gapH8,
          AnimatedBuilder(
            animation: Listenable.merge([
              widget.retailController,
              widget.retailOfferController,
              widget.wholeController,
              widget.wholeOfferController,
              widget.ecommerceController,
              widget.ecommerceOfferController,
            ]),
            builder: (_, _) {
              return PrimaryButton(
                text: 'Confirmar alterações'.hardcoded,
                onPressed: hasChangedAnyValue ? insertUpdate : null,
              );
            },
          ),
        ],
      ),
    );
  }
}
