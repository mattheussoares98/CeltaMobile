import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../components/components.dart';
import 'components/components.dart';

class PhonePage extends StatelessWidget {
  final List<CustomerTelephoneEntity> phones;
  final TextEditingController dddController;
  final TextEditingController phoneController;
  final FocusNode phoneFocusNode;
  final GlobalKey<FormState> formKey;
  final VoidCallback addPhone;
  final void Function(int index) removePhone;
  const PhonePage({
    super.key,
    required this.phones,
    required this.dddController,
    required this.phoneController,
    required this.phoneFocusNode,
    required this.formKey,
    required this.addPhone,
    required this.removePhone,
  });

  static final dddFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Telefones'.hardcoded)),
      body: ResponsiveScrollableWidget(
        child: Form(
          key: formKey,
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
                  Expanded(flex: 3, child: PhoneField(this)),
                ],
              ),
              gapH32,
              PrimaryButton(
                text: 'Adicionar telefone'.hardcoded,
                onPressed: addPhone,
              ),
              if (phones.isNotEmpty) ...[
                DefaultDivider('Telefones informados'.hardcoded),
                InformedPhones(this),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
