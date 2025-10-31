import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../../../core/validators/validators.dart';
import '../../../../../domain/entities/entities.dart';
import 'components.dart';

class DiscountFieldAndTypeDropdown extends StatelessWidget {
  final ProductsItems productsItems;
  final VoidCallback insertProduct;
  final PercentageOrValue? discountType;
  final void Function(PercentageOrValue? discountType) changeDiscountType;
  const DiscountFieldAndTypeDropdown({
    super.key,
    required this.productsItems,
    required this.insertProduct,
    required this.discountType,
    required this.changeDiscountType,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 65,
          child: DefaultTextFormField(
            hintText: 'Desconto'.hardcoded,
            labelText: 'Desconto'.hardcoded,
            controller: productsItems.discountController,
            focusNode: productsItems.discountFocusNode,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            maxLength: 13,
            onFieldSubmitted: (_) {
              insertProduct();
            },
            keyboardType: TextInputType.numberWithOptions(
              decimal: true, //TODO test in IOS
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return null;
              }

              final numberValidator = NumberValidator(allowDecimal: true);

              final isValid = numberValidator.isValid(value);

              if (isValid) {
                return null;
              } else {
                return numberValidator.errorMessage;
              }
            },
          ),
        ),
        gapW8,
        Flexible(
          flex: 35,
          child: DefaultSimpleDropDown<PercentageOrValue?>(
            onChanged: changeDiscountType,
            value: discountType,
            hint: 'Tipo',
            items: [
              DropdownMenuItem(
                value: PercentageOrValue.percentage,
                child: Text(PercentageOrValue.percentage.symbol),
              ),
              DropdownMenuItem(
                value: PercentageOrValue.value,
                child: Text(PercentageOrValue.value.symbol),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
