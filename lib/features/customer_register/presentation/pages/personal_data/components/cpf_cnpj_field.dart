import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../core/validators/validators.dart';
import 'components.dart';

class CpfCnpjField extends StatelessWidget {
  final TextEditingController cpfCnpjController;
  final FocusNode nameFocusNode;
  final VoidCallback onChangeCpfCnpj;
  const CpfCnpjField({
    super.key,
    required this.cpfCnpjController,
    required this.nameFocusNode,
    required this.onChangeCpfCnpj,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTextFormField(
      controller: cpfCnpjController,
      maxLength: 14,
      hintText: 'CPF/CNPJ'.hardcoded,
      labelText: 'CPF/CNPJ'.hardcoded,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onFieldSubmitted: (_) {
        nameFocusNode.requestFocus();
      },
      validator: FormValidators.compose([
        NonEmptyValidator(),
        CpfCnpjValidator(),
      ]),
      onChanged: (_) {
        onChangeCpfCnpj();
      },
      suffixIcon: DefaultDeleteIcon(controller: cpfCnpjController),
    );
  }
}
