import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/validators/validators.dart';
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
      labelText: context.l10n.phone,
      hintText: context.l10n.phone,
      onFieldSubmitted: (_) => addPhone(),
      validator: FormValidators.compose([
        NonEmptyValidator(translations: context.l10n),
        MinLengthValidator(9, translations: context.l10n),
      ]),
    );
  }
}
