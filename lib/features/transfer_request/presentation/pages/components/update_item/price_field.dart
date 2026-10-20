import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/utils/utils.dart';
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
          labelText: context.l10n.price,
          hintText: context.l10n.price,
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
              translations: context.l10n,
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
                  context.l10n.theSelectedOrderTemplateDoesNotAllowPriceChanges,
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
