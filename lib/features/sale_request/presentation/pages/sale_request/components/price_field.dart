import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';

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
