import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../core/validators/validators.dart';

class DddField extends StatelessWidget {
  const DddField({
    super.key,
    required this.dddController,
    required this.phoneFocusNode,
  });

  final TextEditingController dddController;
  final FocusNode phoneFocusNode;

  @override
  Widget build(BuildContext context) {
    return DefaultTextFormField(
      controller: dddController,
      labelText: 'DDD',
      hintText: 'DDD',
      maxLength: 2,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: const TextInputType.numberWithOptions(decimal: false),
      validator: FormValidators.compose([NonEmptyValidator(), DddValidator()]),
      onChanged: (value) {
        if ([
          NonEmptyValidator(),
          DddValidator(),
        ].every((validator) => validator.isValid(value))) {
          phoneFocusNode.requestFocus();
        }
      },
      onFieldSubmitted: (_) {
        phoneFocusNode.requestFocus();
      },
    );
  }
}
