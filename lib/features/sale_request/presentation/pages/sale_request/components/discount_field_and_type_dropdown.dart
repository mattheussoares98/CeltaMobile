import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../../../core/validators/validators.dart';
import '../../../../domain/entities/entities.dart';

class DiscountFieldAndTypeDropdown extends StatelessWidget {
  final VoidCallback insertProduct;
  final PercentageOrValue? discountType;
  final void Function(PercentageOrValue? discountType) changeDiscountType;
  final TextEditingController discountController;
  final FocusNode discountFocusNode;
  const DiscountFieldAndTypeDropdown({
    super.key,
    required this.insertProduct,
    required this.discountType,
    required this.changeDiscountType,
    required this.discountController,
    required this.discountFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;
    return Row(
      children: [
        Expanded(
          flex: 65,
          child: DefaultTextFormField(
            hintText: 'Desconto'.hardcoded,
            labelText: 'Desconto'.hardcoded,
            controller: discountController,
            focusNode: discountFocusNode,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            maxLength: 13,
            suffixIcon: IconButton(
              onPressed: () {
                showAlertDialog(
                  context: context,
                  title: 'Atenção!'.hardcoded,
                  content:
                      'Esse campo está habilitado porque o modelo de pedido permite inserir desconto'
                          .hardcoded,
                );
              },
              icon: Icon(isIOS ? CupertinoIcons.info : Icons.info),
            ),
            onFieldSubmitted: (_) {
              insertProduct();
            },
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true, //TODO test in IOS
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return null;
              }

              final numberValidator = NumberValidator(
                allowDecimal: true,
                needsBeGreaterThanZero: false,
              );

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
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (discountType == null && discountController.text.isNotEmpty) {
                return 'Campo obrigatório'.hardcoded;
              }

              return null;
            },
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
