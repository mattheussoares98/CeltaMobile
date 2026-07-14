import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/features/customer_register/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/customer_register/presentation/pages/personal_data/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CpfCnpjField extends ConsumerWidget {
  final TextEditingController cpfCnpjController;
  final FocusNode nameFocusNode;
  final FocusNode cpfCnpjFocusNode;
  const CpfCnpjField({
    super.key,
    required this.cpfCnpjController,
    required this.nameFocusNode,
    required this.cpfCnpjFocusNode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseTextFormField(
      key: const ValueKey('CPF/CNPJ'),
      controller: cpfCnpjController,
      focusNode: cpfCnpjFocusNode,
      maxLength: 14,
      hintText: 'CPF/CNPJ'.hardcoded,
      labelText: 'CPF/CNPJ'.hardcoded,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: const TextInputType.numberWithOptions(),
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
