import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PhoneField extends ConsumerWidget {
  final TextEditingController phoneController;
  final FocusNode phoneFocusNode;
  final VoidCallback addPhone;
  const PhoneField({
    super.key,
    required this.phoneController,
    required this.phoneFocusNode,
    required this.addPhone,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseTextFormField(
      key: const ValueKey('Phone'),
      controller: phoneController,
      focusNode: phoneFocusNode,
      maxLength: 10,
      inputFormatters: [PhoneInputFormatter()],
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: const TextInputType.numberWithOptions(),
      labelText: 'Telefone'.hardcoded,
      hintText: 'Telefone'.hardcoded,
      onFieldSubmitted: (_) => addPhone(),
      validator: FormValidators.compose([
        const NonEmptyValidator(),
        MinLengthValidator(9),
      ]),
    );
  }
}
