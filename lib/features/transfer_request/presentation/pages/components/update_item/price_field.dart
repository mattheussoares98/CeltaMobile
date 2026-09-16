import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PriceField extends StatelessWidget {
  final TextEditingController priceController;
  final FocusNode priceFocusNode;
  final VoidCallback update;
  final bool requestTypeAllowChangePrice;
  const PriceField({
    super.key,
    required this.priceController,
    required this.priceFocusNode,
    required this.update,
    required this.requestTypeAllowChangePrice,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BaseTextFormField(
          labelText: 'Preço'.hardcoded,
          hintText: 'Preço'.hardcoded,
          enabled: requestTypeAllowChangePrice,
          controller: priceController,
          focusNode: priceFocusNode,
          onFieldSubmitted: (_) => update(),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          maxLength: 13,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onTap: () {
            if (priceFocusNode.hasFocus) {
              return;
            }

            priceController.selection = TextSelection(
              baseOffset: 0,
              extentOffset: priceController.text.length,
            );
          },
          validator: FormValidators.compose([
            NumberValidator(
              allowDecimal: true,
              allowEmptyValue: !requestTypeAllowChangePrice,
            ),
          ]),
        ),
        if (!requestTypeAllowChangePrice)
          Positioned(
            right: Sizes.p4,
            top: 0,
            bottom: 0,
            child: Tooltip(
              showDuration: const Duration(seconds: 5),
              triggerMode: TooltipTriggerMode.tap,
              message:
                  'O modelo de pedido selecionado não permite alterar o preço'
                      .hardcoded,
              child: const PlatformIcon(
                cupertinoIcon: CupertinoIcons.info_circle,
                materialIcon: Icons.info,
              ),
            ),
          ),
      ],
    );
  }
}
