import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../core/validators/validators.dart';

class PhoneField extends ConsumerWidget {
  final CustomerEntity? customer;
  final GlobalKey<FormState> formKey;
  final TextEditingController dddController;
  final TextEditingController phoneController;
  final FocusNode phoneFocusNode;
  final VoidCallback addPhone;
  const PhoneField({
    super.key,
    required this.customer,
    required this.formKey,
    required this.dddController,
    required this.phoneController,
    required this.phoneFocusNode,
    required this.addPhone,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTextFormField(
      controller: phoneController,
      focusNode: phoneFocusNode,
      inputFormatters: [PhoneInputFormatter()],
      autovalidateMode: AutovalidateMode.onUserInteraction,
      labelText: 'Telefone'.hardcoded,
      hintText: 'Telefone'.hardcoded,
      onFieldSubmitted: (_) {
        addPhone();
      },
      validator: FormValidators.compose([
        NonEmptyValidator(),
        MinLengthValidator(8),
        NumberValidator(allowDecimal: false),
      ]),
    );
  }
}
