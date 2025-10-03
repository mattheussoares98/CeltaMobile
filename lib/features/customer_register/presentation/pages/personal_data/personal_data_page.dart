import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/validators/validators.dart';

class PersonalDataPage extends ConsumerStatefulWidget {
  //TODO analyse if is possible to change the stateful to stateless
  final CustomerEntity? customer;
  final TextEditingController cpfCnpjController;
  final TextEditingController nameController;
  final TextEditingController reducedNameController;
  final TextEditingController passwordController;
  final TextEditingController passwordConfirmationController;
  final FocusNode nameFocusNode;
  final FocusNode reducedNameFocusNode;
  final FocusNode passwordFocusNode;
  final FocusNode passwordConfirmationFocusNode;
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
    required this.nameFocusNode,
    required this.reducedNameFocusNode,
    required this.passwordFocusNode,
    required this.passwordConfirmationFocusNode,
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
      appBar: AppBar(title: const Text('PersonalDataPage')),
      body: ResponsiveScrollableWidget(
        child: Form(
          key: widget.formKey,
          child: Column(
            children: [
              DefaultTextFormField(
                controller: widget.cpfCnpjController,
                maxLength: 14,
                hintText: 'CPF/CNPJ'.hardcoded,
                labelText: 'CPF/CNPJ'.hardcoded,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onFieldSubmitted: (_) {
                  widget.nameFocusNode.requestFocus();
                },
                validator: FormValidators.compose([
                  NonEmptyValidator(),
                  CpfCnpjValidator(),
                ]),
                onChanged: (_) {
                  widget.onChangeCpfCnpj();
                },
              ),
              if (widget.customer != null) ...[
                gapH8,
                DefaultTextFormField(
                  controller: widget.nameController,
                  maxLength: 50,
                  hintText: 'Nome'.hardcoded,
                  labelText: 'Nome'.hardcoded,
                  focusNode: widget.nameFocusNode,
                  validator: FormValidators.compose([
                    NonEmptyValidator(),
                    MinLengthValidator(3),
                  ]),
                  onFieldSubmitted: (_) {
                    widget.reducedNameFocusNode.requestFocus();
                  },
                ),
                gapH8,
                DefaultTextFormField(
                  controller: widget.reducedNameController,
                  maxLength: 30,
                  hintText: 'Nome reduzido'.hardcoded,
                  labelText: 'Nome reduzido'.hardcoded,
                  focusNode: widget.reducedNameFocusNode,
                  onFieldSubmitted: (_) {
                    widget.passwordFocusNode.requestFocus();
                  },
                ),
                gapH8,
                DefaultTextFormField(
                  controller: widget.passwordController,
                  maxLength: 20,
                  hintText: 'Senha'.hardcoded,
                  labelText: 'Senha'.hardcoded,
                  focusNode: widget.passwordFocusNode,
                  onFieldSubmitted: (_) {
                    widget.passwordConfirmationFocusNode.requestFocus();
                  },
                ),
                gapH8,
                DefaultTextFormField(
                  controller: widget.passwordConfirmationController,
                  maxLength: 20,
                  hintText: 'Confirmar senha'.hardcoded,
                  labelText: 'Confirmar senha'.hardcoded,
                  focusNode: widget.passwordConfirmationFocusNode,
                ),
                DefaultSimpleDropDown<String?>(
                  value: selectedSex,
                  hint: 'Sexo'.hardcoded,
                  onChanged: (_) {},
                  items: ['Masculino', 'Feminino']
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Center(child: Text(e)),
                        ),
                      )
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
