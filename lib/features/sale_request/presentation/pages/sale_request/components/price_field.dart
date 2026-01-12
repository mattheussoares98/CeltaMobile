import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../core/validators/validators.dart';
import 'components.dart';

class PriceField extends StatelessWidget {
  final VoidCallback insertProduct;
  final QuantityPriceDiscountFieldsAndInsertButton widget;
  const PriceField({
    super.key,
    required this.insertProduct,
    required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return AnimatedBuilder(
      animation: widget.discountController,
      builder: (_, _) {
        bool enabled = widget.discountController.text.isEmpty;
        return Row(
          children: [
            Expanded(
              child: DefaultTextFormField(
                labelText: 'Preço manual'.hardcoded,
                hintText: 'Preço manual'.hardcoded,
                maxLength: 13,
                controller: widget.priceController,
                focusNode: widget.priceFocusNode,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                enabled: enabled,
                onFieldSubmitted: (_) {
                  if (widget.selectedRequest.AllowDiscount == true &&
                      widget.priceController.text.isEmpty) {
                    widget.discountFocusNode.requestFocus();
                  } else {
                    insertProduct();
                  }
                },
                validator: FormValidators.compose([
                  NumberValidator(allowDecimal: true, allowEmptyValue: true),
                ]),
              ),
            ),
            FocusTraversalGroup(
              descendantsAreFocusable: false,
              child: IconButton(
                onPressed: () {
                  showAlertDialog(
                    context: context,
                    title: 'Atenção!'.hardcoded,
                    content:
                        'Esse campo fica habilitado quando o modelo de pedido permite alterar o preço e não foi informado um desconto manualmente'
                            .hardcoded,
                  );
                },
                icon: Icon(isIOS ? CupertinoIcons.info : Icons.info),
              ),
            ),
          ],
        );
      },
    );
  }
}
