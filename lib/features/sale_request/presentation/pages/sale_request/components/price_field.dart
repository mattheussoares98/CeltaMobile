import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../core/validators/validators.dart';
import '../../../../../../core/domain/entities/entities.dart';

class PriceField extends StatelessWidget {
  final VoidCallback insertProduct;
  final TextEditingController priceController;
  final FocusNode priceFocusNode;
  final FocusNode discountFocusNode;
  final RequestTypeEntity selectedRequest;
  const PriceField({
    super.key,
    required this.insertProduct,
    required this.priceController,
    required this.priceFocusNode,
    required this.discountFocusNode,
    required this.selectedRequest,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return DefaultTextFormField(
      labelText: 'Preço'.hardcoded,
      hintText: 'Preço'.hardcoded,
      maxLength: 13,
      controller: priceController,
      focusNode: priceFocusNode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      suffixIcon: IconButton(
        onPressed: () {
          showAlertDialog(
            context: context,
            title: 'Atenção!'.hardcoded,
            content:
                'Esse campo está habilitado porque o modelo de pedido permite alterar o preço'
                    .hardcoded,
          );
        },
        icon: Icon(isIOS ? CupertinoIcons.info : Icons.info),
      ),
      onFieldSubmitted: (_) {
        if (selectedRequest.AllowDiscount == true) {
          discountFocusNode.requestFocus();
        } else {
          insertProduct();
        }
      },
      validator: FormValidators.compose([
        NonEmptyValidator(),
        NumberValidator(allowDecimal: true),
      ]),
    );
  }
}
