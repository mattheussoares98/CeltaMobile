import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../../../core/validators/validators.dart';
import '../../../../domain/entities/entities.dart';
import '../../../controllers/controllers.dart';
import 'components.dart';

class DiscountFieldAndTypeDropdown extends ConsumerWidget {
  final VoidCallback insertProduct;
  final QuantityPriceDiscountFieldsAndInsertButton widget;
  const DiscountFieldAndTypeDropdown({
    super.key,
    required this.insertProduct,
    required this.widget,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    final discountType = ref.watch(
      selectedItemUIControllerProvider(
        isCartPage: widget.isCartPage,
      ).select((state) => state.discountType),
    );

    return Row(
      children: [
        Expanded(
          flex: 65,
          child: Row(
            children: [
              Expanded(
                child: DefaultTextFormField(
                  hintText: 'Desconto unitário'.hardcoded,
                  labelText: 'Desconto unitário'.hardcoded,
                  controller: widget.discountController,
                  focusNode: widget.discountFocusNode,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  maxLength: 13,
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
              FocusTraversalGroup(
                descendantsAreFocusable: false,
                child: IconButton(
                  onPressed: () {
                    showAlertDialog(
                      context: context,
                      title: 'Atenção!'.hardcoded,
                      content:
                          'Esse campo fica habilitado quando o modelo de pedido permite aplicar desconto e não foi informado um preço manualmente'
                              .hardcoded,
                    );
                  },
                  icon: Icon(isIOS ? CupertinoIcons.info : Icons.info),
                ),
              ),
            ],
          ),
        ),
        gapW8,
        Flexible(
          flex: 35,
          child: FocusTraversalGroup(
            descendantsAreFocusable: false,
            child: DefaultSimpleDropDown<PercentageOrValue?>(
              onChanged: (value) {
                ref
                    .read(
                      selectedItemUIControllerProvider(
                        isCartPage: widget.isCartPage,
                      ).notifier,
                    )
                    .updateDiscountType(value);
              },
              value: discountType,
              hint: 'Tipo',
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (discountType == null &&
                    widget.discountController.text.isNotEmpty) {
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
        ),
      ],
    );
  }
}
