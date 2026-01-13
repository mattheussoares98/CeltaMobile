import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../../../core/validators/validators.dart';
import '../../../../controllers/controllers.dart';

class PriceField extends ConsumerWidget {
  final TextEditingController priceController;
  final FocusNode priceFocusNode;
  final VoidCallback update;
  final int requestTypeCode;
  const PriceField({
    super.key,
    required this.priceController,
    required this.priceFocusNode,
    required this.update,
    required this.requestTypeCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestTypeAllowChangePrice = ref.watch(
      uiStateControllerProvider(
        requestTypeCode,
      ).select((s) => s.value?.requestTypeAllowChangePrice ?? false),
    );
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;
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
            right: Sizes.p8,
            bottom: Sizes.p8,
            child: Tooltip(
              triggerMode: TooltipTriggerMode.tap,
              message:
                  'O modelo de pedido selecionado não permite alterar o preço'
                      .hardcoded,
              child: Icon(isIOS ? CupertinoIcons.info_circle : Icons.info),
            ),
          ),
      ],
    );
  }
}
