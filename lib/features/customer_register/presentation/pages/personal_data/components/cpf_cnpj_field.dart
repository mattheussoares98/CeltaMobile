import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../core/validators/validators.dart';
import '../../../controllers/controllers.dart';
import 'components.dart';

class CpfCnpjField extends ConsumerWidget {
  final TextEditingController cpfCnpjController;
  final FocusNode nameFocusNode;
  const CpfCnpjField({
    super.key,
    required this.cpfCnpjController,
    required this.nameFocusNode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTextFormField(
      controller: cpfCnpjController,
      maxLength: 14,
      hintText: 'CPF/CNPJ'.hardcoded,
      labelText: 'CPF/CNPJ'.hardcoded,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: const TextInputType.numberWithOptions(decimal: false),
      onFieldSubmitted: (_) {
        nameFocusNode.requestFocus();
      },
      validator: FormValidators.compose([
        NonEmptyValidator(),
        CpfCnpjValidator(),
      ]),
      onChanged: (value) {
        if (CpfCnpjValidator().isValid(value)) {
          ref
              .read(customerStateControllerProvider.notifier)
              .loadCustomer(value);
        }
      },
      suffixIcon: DefaultDeleteIcon(controller: cpfCnpjController),
    );
  }
}
