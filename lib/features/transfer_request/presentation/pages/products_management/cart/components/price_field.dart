import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../core/validators/validators.dart';

class PriceField extends StatelessWidget {
  final TextEditingController priceController;
  final FocusNode priceFocusNode;
  final VoidCallback update;
  const PriceField({
    super.key,
    required this.priceController,
    required this.priceFocusNode,
    required this.update,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTextFormField(
      labelText: 'Preço'.hardcoded,
      hintText: 'Preço'.hardcoded,
      controller: priceController,
      focusNode: priceFocusNode,
      onFieldSubmitted: (_) => update(),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      maxLength: 13,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
        //TODO test in iOS
      ),
      validator: FormValidators.compose([
        NonEmptyValidator(),
        NumberValidator(allowDecimal: true, maxDecimalHouses: 2),
      ]),
    );
  }
}
