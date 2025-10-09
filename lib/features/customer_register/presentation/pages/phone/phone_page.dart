import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../components/components.dart';
import 'components/components.dart';

class PhonePage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    void addPhone() {
      // setState(() {
      //   phones.add(
      //     CustomerTelephoneEntity(
      //       AreaCode: dddController.text,
      //       PhoneNumber: phoneController.text,
      //     ),
      //   );
      // });

      dddController.clear();
      phoneController.clear();
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
