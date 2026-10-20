import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';

class QuantityField extends StatelessWidget {
  final TextEditingController quantityController;
  final TextEditingController priceController;
  final FocusNode quantityFocusNode;
  final FocusNode priceFocusNode;
  final bool requestTypeAllowChangePrice;
  final VoidCallback update;
  const QuantityField({
    super.key,
    required this.quantityController,
    required this.priceController,
    required this.quantityFocusNode,
    required this.priceFocusNode,
    required this.requestTypeAllowChangePrice,
    required this.update,
  });

  @override
  Widget build(BuildContext context) {
    return BaseTextFormField(
      labelText: context.l10n.quantity,
      hintText: context.l10n.quantity,
      controller: quantityController,
      focusNode: quantityFocusNode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      maxLength: 13,
      onTap: () {
        if (quantityFocusNode.hasFocus) return;
        quantityController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: quantityController.text.length,
        );
      },
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onFieldSubmitted: (_) {
        if (requestTypeAllowChangePrice) {
          priceFocusNode.requestFocus();
          priceController.selection = TextSelection(
            baseOffset: 0,
            extentOffset: priceController.text.length,
          );
        } else {
          update();
        }
      },
      validator: FormValidators.compose([
        NonEmptyValidator(translations: context.l10n),
        NumberValidator(
          translations: context.l10n,
          allowDecimal: true,
          maxDecimalHouses: 3,
        ),
      ]),
    );
  }
}
