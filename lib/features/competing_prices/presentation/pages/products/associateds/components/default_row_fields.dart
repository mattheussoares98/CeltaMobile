import 'package:flutter/material.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../../../core/validators/validators.dart';
import '../../../../../../../localization/string_hardcoded.dart';
import 'components.dart';

class DefaultRowFields extends StatelessWidget {
  final TextEditingController controller;
  final TextEditingController offerController;
  final FocusNode focusNode;
  final FocusNode offerFocusNode;
  final String priceType;
  final VoidCallback onSubmit;

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
          child: DefaultTextFormField(
            controller: controller,
            focusNode: focusNode,
            labelText: priceType,
            hintText: priceType,
            maxLength: 13,
            suffixIcon: DefaultDeleteIcon(controller, focusNode),
            onFieldSubmitted: (_) => offerFocusNode.requestFocus(),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: FormValidators.compose([
              NumberValidator(allowDecimal: true, allowEmptyValue: true),
            ]),
          ),
        ),
        gapW4,
        Expanded(
          child: DefaultTextFormField(
            controller: offerController,
            focusNode: offerFocusNode,
            onFieldSubmitted: (_) => onSubmit(),
            labelText: '$priceType (oferta)'.hardcoded,
            hintText: '$priceType (oferta)'.hardcoded,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            maxLength: 13,
            suffixIcon: DefaultDeleteIcon(offerController, offerFocusNode),
            validator: FormValidators.compose([
              NumberValidator(allowDecimal: true, allowEmptyValue: true),
            ]),
          ),
        ),
      ],
    );
  }
}
