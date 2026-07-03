import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/features/competing_prices/presentation/pages/products/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

class DefaultRowFields extends StatelessWidget {
  final TextEditingController controller;
  final TextEditingController offerController;
  final FocusNode focusNode;
  final FocusNode offerFocusNode;
  final String priceType;
  final VoidCallback? onSubmit;

  const DefaultRowFields({
    super.key,
    required this.controller,
    required this.offerController,
    required this.focusNode,
    required this.offerFocusNode,
    required this.priceType,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: BaseTextFormField(
            controller: controller,
            focusNode: focusNode,
            labelText: priceType,
            hintText: priceType,
            maxLength: 13,
            suffixIcon: DefaultDeleteIcon(controller, focusNode),
            onFieldSubmitted: (_) => offerFocusNode.requestFocus(),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: FormValidators.compose([
              NumberValidator(
                allowDecimal: true,
                allowEmptyValue: true,
                needsBeGreaterThanZero: false,
              ),
            ]),
          ),
        ),
        gapW4,
        Expanded(
          child: BaseTextFormField(
            controller: offerController,
            focusNode: offerFocusNode,
            onFieldSubmitted: (_) => onSubmit?.call(),
            labelText: '$priceType (oferta)'.hardcoded,
            hintText: '$priceType (oferta)'.hardcoded,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            maxLength: 13,
            suffixIcon: DefaultDeleteIcon(offerController, offerFocusNode),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: FormValidators.compose([
              NumberValidator(
                allowDecimal: true,
                allowEmptyValue: true,
                needsBeGreaterThanZero: false,
              ),
            ]),
          ),
        ),
      ],
    );
  }
}
