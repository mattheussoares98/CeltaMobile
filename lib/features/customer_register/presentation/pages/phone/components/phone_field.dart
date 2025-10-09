import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../core/validators/validators.dart';
import '../../../controllers/controllers.dart';

class PhoneField extends ConsumerWidget {
  final CustomerEntity? customer;
  final GlobalKey<FormState> formKey;
  final TextEditingController dddController;
  final TextEditingController phoneController;
  final FocusNode phoneFocusNode;
  const PhoneField({
    super.key,
    required this.customer,
    required this.formKey,
    required this.dddController,
    required this.phoneController,
    required this.phoneFocusNode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void insertPhone() {
      if (formKey.currentState?.validate() != true) {
        return;
      } else if (customer?.Telephones?.any(
            (e) =>
                e.PhoneNumber == phoneController.text &&
                e.AreaCode == dddController.text,
          ) ??
          false) {
        showSnackBarMessage(
          context,
          'Esse telefone já foi adicionado'.hardcoded,
          backgroundColor: Colors.red,
        );
        return;
      }

      ref
          .read(customerStateControllerProvider.notifier)
          .updateCustomer(
            customer!.copyWith(
              Telephones: (customer?.Telephones ?? [])
                ..add(
                  CustomerTelephoneEntity(
                    AreaCode: dddController.text,
                    PhoneNumber: phoneController.text,
                  ),
                ),
            ),
          );
      phoneController.clear();
      dddController.clear();
    }

    return DefaultTextFormField(
      controller: phoneController,
      focusNode: phoneFocusNode,
      inputFormatters: [PhoneInputFormatter()],
      autovalidateMode: AutovalidateMode.onUserInteraction,
      labelText: 'Telefone'.hardcoded,
      hintText: 'Telefone'.hardcoded,
      onFieldSubmitted: (_) {
        insertPhone();
      },
      validator: FormValidators.compose([
        NonEmptyValidator(),
        MinLengthValidator(8),
        NumberValidator(allowDecimal: false),
      ]),
    );
  }
}
