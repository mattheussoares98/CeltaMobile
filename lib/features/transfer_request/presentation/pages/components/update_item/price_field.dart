import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/features/transfer_request/presentation/controllers/controllers.dart';

class PriceField extends ConsumerWidget {
  final TextEditingController priceController;
  final FocusNode priceFocusNode;
  final VoidCallback update;
  final int requestTypeCode;
  final int enterpriseCode;
  const PriceField({
    super.key,
    required this.priceController,
    required this.priceFocusNode,
    required this.update,
    required this.requestTypeCode,
    required this.enterpriseCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestTypeAllowChangePrice = ref.watch(
      uiStateControllerProvider(
        requestTypeCode,
        enterpriseCode,
      ).select((s) => s.value?.requestTypeAllowChangePrice ?? false),
    );
    return Stack(
      children: [
        DefaultTextFormField(
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
              maxDecimalHouses: 2,
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
