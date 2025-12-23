import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../core/validators/validators.dart';

class DddField extends StatelessWidget {
  const DddField({
    super.key,
    required this.dddController,
    required this.dddFormKey,
    required this.phoneFocusNode,
  });

  final TextEditingController dddController;
  final GlobalKey<FormState> dddFormKey;
  final FocusNode phoneFocusNode;

  @override
  Widget build(BuildContext context) {
    return DefaultTextFormField(
      controller: dddController,
      labelText: 'DDD',
      hintText: 'DDD',
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: const TextInputType.numberWithOptions(decimal: false),
      validator: FormValidators.compose([NonEmptyValidator(), DddValidator()]),
      onChanged: (value) {
        if (dddFormKey.currentState?.validate() == true) {
          phoneFocusNode.requestFocus();
        }
      },
      onFieldSubmitted: (_) {
        phoneFocusNode.requestFocus();
      },
    );
  }
}
