import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import 'components/components.dart';

class PersonalDataPage extends StatelessWidget {
  //TODO analyse if is possible to change the stateful to stateless
  final CustomerEntity? customer;
  final TextEditingController cpfCnpjController;
  final TextEditingController nameController;
  final TextEditingController reducedNameController;
  final TextEditingController passwordController;
  final TextEditingController passwordConfirmationController;
  final TextEditingController birthDateController;
  final TextEditingController inscriptionController;
  final FocusNode nameFocusNode;
  final FocusNode reducedNameFocusNode;
  final FocusNode passwordFocusNode;
  final FocusNode passwordConfirmationFocusNode;
  final FocusNode birthDateFocusNode;
  final FocusNode inscriptionFocusNode;
  final GlobalKey<FormState> formKey;
  final VoidCallback onChangeCpfCnpj;
  final CustomerSexType? selectedSex;
  final Function(CustomerSexType? value) onChangeSex;
  const PersonalDataPage({
    super.key,
    required this.customer,
    required this.cpfCnpjController,
    required this.nameController,
    required this.reducedNameController,
    required this.passwordController,
    required this.passwordConfirmationController,
    required this.birthDateController,
    required this.inscriptionController,
    required this.nameFocusNode,
    required this.reducedNameFocusNode,
    required this.passwordFocusNode,
    required this.passwordConfirmationFocusNode,
    required this.birthDateFocusNode,
    required this.inscriptionFocusNode,
    required this.formKey,
    required this.onChangeCpfCnpj,
    required this.selectedSex,
    required this.onChangeSex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //TODO chack which fields are obligatory
      appBar: AppBar(title: Text('Dados pessoais'.hardcoded)),
      body: ResponsiveScrollableWidget(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              CpfCnpjField(this),
              if (customer != null) ...[
                if (cpfCnpjController.text.length == 14) ...[
                  gapH8,
                  InscriptionField(this),
                ],
                gapH8,
                NameField(this),
                gapH8,
                ReducedNameField(this),
                gapH8,
                BirthDateField(this),
                gapH8,
                PasswordField(this),
                gapH8,
                PasswordConfirmationField(this),
                if (cpfCnpjController.text.length == 11) ...[
                  gapH8,
                  SexDropDown(this),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
