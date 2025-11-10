import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../core/validators/validators.dart';
import 'components.dart';

class QuantityField extends StatefulWidget {
  final VoidCallback insertProduct;
  final QuantityPriceDiscountFieldsAndInsertButton widget;
  const QuantityField({
    super.key,
    required this.insertProduct,
    required this.widget,
  });

  @override
  State<QuantityField> createState() => _QuantityFieldState();
}

class _QuantityFieldState extends State<QuantityField> {
  double get practicedPrice {
    final totalQuantity = widget.widget.quantityController.text.toDouble() ?? 0;

    if (widget.widget.product.MinimumWholeQuantity > 0 &&
        totalQuantity >= widget.widget.product.MinimumWholeQuantity &&
        widget.widget.product.WholePracticedPrice > 0) {
      return widget.widget.product.WholePracticedPrice;
    } else if (widget.widget.product.getPrice == 0 &&
        (widget.widget.cartProduct?.Value ?? 0) > 0) {
      return widget.widget.cartProduct!.Value;
    }
    return widget.widget.product.getPrice;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        updatePrice();
      }
    });
  }

  void updatePrice() {
    Future.delayed(const Duration(milliseconds: 100), () {
      widget.widget.priceController.text = practicedPrice
          .toString()
          .toBrazilianNumber()
          .replaceAll(RegExp(r'\.'), '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextFormField(
      labelText: 'Quantidade'.hardcoded,
      hintText: 'Quantidade'.hardcoded,
      maxLength: 13,
      controller: widget.widget.quantityController,
      focusNode: widget.widget.quantityFocusNode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (_) => updatePrice(),
      onFieldSubmitted: (_) {
        if (widget.widget.selectedRequest.AllowAlterCostOrSalePrice == true) {
          widget.widget.priceFocusNode.requestFocus();
        } else {
          widget.insertProduct();
        }
      },
      validator: FormValidators.compose([
        NonEmptyValidator(),
        NumberValidator(allowDecimal: true),
      ]),
    );
  }
}
