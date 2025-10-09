import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../controllers/controllers.dart';
import '../components/components.dart';
import 'components/components.dart';

class PhonePage extends ConsumerWidget {
  final TextEditingController dddController;
  final TextEditingController phoneController;
  final FocusNode phoneFocusNode;
  final CustomerEntity? customer;
  const PhonePage({
    super.key,
    required this.dddController,
    required this.phoneController,
    required this.phoneFocusNode,
    required this.customer,
  });

  static final dddFormKey = GlobalKey<FormState>();
  static final phoneFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void addPhone() {
      if (phoneFormKey.currentState?.validate() != true) {
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

    return Scaffold(
      appBar: AppBar(title: Text('Telefones'.hardcoded)),
      body: ResponsiveScrollableWidget(
        child: Form(
          key: phoneFormKey,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Form(
                      key: dddFormKey,
                      child: DddField(
                        dddController: dddController,
                        dddFormKey: dddFormKey,
                        phoneFocusNode: phoneFocusNode,
                      ),
                    ),
                  ),
                  gapW8,
                  Expanded(
                    flex: 3,
                    child: PhoneField(
                      customer: customer,
                      formKey: phoneFormKey,
                      dddController: dddController,
                      phoneController: phoneController,
                      phoneFocusNode: phoneFocusNode,
                      addPhone: addPhone,
                    ),
                  ),
                ],
              ),
              gapH32,
              PrimaryButton(
                text: 'Adicionar telefone'.hardcoded,
                onPressed: addPhone,
              ),
              if (customer?.Telephones != null &&
                  customer!.Telephones!.isNotEmpty) ...[
                DefaultDivider('Telefones informados'.hardcoded),
                InformedPhones(customer: customer),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
