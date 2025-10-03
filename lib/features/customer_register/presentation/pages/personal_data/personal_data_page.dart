import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import 'components/components.dart';

class PersonalDataPage extends ConsumerStatefulWidget {
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
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PersonalDataPageState();
}

class _PersonalDataPageState extends ConsumerState<PersonalDataPage> {
  String? selectedSex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //TODO chack which fields are obligatory
      appBar: AppBar(title: Text('Dados pessoais'.hardcoded)),
      body: ResponsiveScrollableWidget(
        child: Form(
          key: widget.formKey,
          child: Column(
            children: [
              CpfCnpjField(widget),
              if (widget.customer != null) ...[
                if (widget.cpfCnpjController.text.length == 14) ...[
                  gapH8,
                  InscriptionField(widget),
                ],
                gapH8,
                NameField(widget),
                gapH8,
                ReducedNameField(widget),
                gapH8,
                BirthDateField(widget),
                gapH8,
                PasswordField(widget),
                gapH8,
                PasswordConfirmationField(widget),
                if (widget.cpfCnpjController.text.length == 11)
                  SexDropDown(selectedSex: selectedSex),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
