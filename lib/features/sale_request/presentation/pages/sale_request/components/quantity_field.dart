import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../core/validators/validators.dart';
import '../../../../../../core/domain/entities/entities.dart';

class QuantityField extends StatelessWidget {
  final VoidCallback insertProduct;
  final TextEditingController quantityController;
  final FocusNode quantityFocusNode;
  final FocusNode priceFocusNode;
  final RequestTypeEntity selectedRequest;
  const QuantityField({
    super.key,
    required this.insertProduct,
    required this.quantityController,
    required this.quantityFocusNode,
    required this.priceFocusNode,
    required this.selectedRequest,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTextFormField(
      labelText: 'Quantidade'.hardcoded,
      hintText: 'Quantidade'.hardcoded,
      maxLength: 13,
      controller: quantityController,
      focusNode: quantityFocusNode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onFieldSubmitted: (_) {
        if (selectedRequest.AllowAlterCostOrSalePrice == true) {
          priceFocusNode.requestFocus();
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
