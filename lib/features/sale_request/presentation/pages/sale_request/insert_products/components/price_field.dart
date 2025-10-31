import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../core/domain/entities/entities.dart';
import '../../../../../../../core/validators/validators.dart';

class PriceField extends StatelessWidget {
  final TextEditingController priceController;
  final FocusNode priceFocusNode;
  final VoidCallback insertProduct;
  final RequestTypeEntity selectedRequest;
  final FocusNode discountFocusNode;

  const PriceField({
    super.key,
    required this.priceController,
    required this.priceFocusNode,
    required this.insertProduct,
    required this.selectedRequest,
    required this.discountFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTextFormField(
      labelText: 'Preço'.hardcoded,
      hintText: 'Preço'.hardcoded,
      maxLength: 13,
      controller: priceController,
      focusNode: priceFocusNode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
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
