import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/customer_register/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/customer_register/presentation/pages/personal_data/components/components.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class PersonalDataPage extends ConsumerStatefulWidget {
  const PersonalDataPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      PersonalDataPageState();
}

class PersonalDataPageState extends ConsumerState<PersonalDataPage> {
  final cpfCnpjController = TextEditingController();
  final nameController = TextEditingController();
  final reducedNameController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();
  final birthDateController = TextEditingController();
  final inscriptionController = TextEditingController();
  final nameFocusNode = FocusNode();
  final cpfCnpjFocusNode = FocusNode();
  final reducedNameFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final passwordConfirmationFocusNode = FocusNode();
  final birthDateFocusNode = FocusNode();
  final inscriptionFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await updateFields();
    });
  }

  @override
  void dispose() {
    super.dispose();
    cpfCnpjController.dispose();
    nameController.dispose();
    reducedNameController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();
    birthDateController.dispose();
    inscriptionController.dispose();
    nameFocusNode.dispose();
    cpfCnpjFocusNode.dispose();
    reducedNameFocusNode.dispose();
    passwordFocusNode.dispose();
    passwordConfirmationFocusNode.dispose();
    birthDateFocusNode.dispose();
    inscriptionFocusNode.dispose();
  }

  bool validate() {
    return formKey.currentState?.validate() ?? false;
  }

  Future<void> updateCustomerInProvider() async {
    //! use in the CustomerRegisterPage
    final customer = await ref.read(customerStateControllerProvider.future);
    if (customer == null) return;

    ref
        .read(customerStateControllerProvider.notifier)
        .updatePersonalData(
          CpfCnpjNumber: cpfCnpjController.text,
          PersonType: cpfCnpjController.text.length == 11
              ? CustomerPersonType.fisica
              : CustomerPersonType.juridica,
          RegistrationNumber: inscriptionController.text,
          Name: nameController.text,
          ReducedName: reducedNameController.text,
          Password: passwordController.text,
          DateOfBirth: DateFormat('dd/MM/yyyy').tryParse(
            birthDateController.text.isEmpty
                ? '01/01/0001'
                : birthDateController.text,
          ),
        );
  }

  Future<void> updateFields({bool? clearCpf}) async {
    final customer = await ref.read(customerStateControllerProvider.future);

    cpfCnpjController.text =
        customer?.CpfCnpjNumber ??
        (clearCpf ?? false ? '' : cpfCnpjController.text);
    inscriptionController.text = customer?.RegistrationNumber ?? '';
    nameController.text = customer?.Name ?? '';
    reducedNameController.text = customer?.ReducedName ?? '';
    passwordController.text = customer?.Password ?? '';
    passwordConfirmationController.text = customer?.Password ?? '';

    if (customer?.DateOfBirth != null) {
      final day = customer?.DateOfBirth!.day.toString().padLeft(2, '0');
      final month = customer?.DateOfBirth!.month.toString().padLeft(2, '0');
      final year = customer?.DateOfBirth!.year.toString().padLeft(4, '0');
      if (day == '01' && month == '01' && year == '0001') {
        birthDateController.text = '';
      } else {
        birthDateController.text = '$day/$month/$year';
      }
    } else {
      birthDateController.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(customerStateControllerProvider, (p, n) {
      n.doOnSuccess(p, () {
        updateFields();
      });
    });

    final customer = ref.watch(customerStateControllerProvider).value;

    return BaseScaffold(
      resizeToAvoidBottomInset: true,
      safeAreaTop: false,
      usePadding: false,
      body: ResponsiveScrollableWidget(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              CpfCnpjField(
                cpfCnpjController: cpfCnpjController,
                nameFocusNode: nameFocusNode,
                cpfCnpjFocusNode: cpfCnpjFocusNode,
              ),
              if (customer != null) ...[
                if (cpfCnpjController.text.length == 14) ...[
                  gapH8,
                  InscriptionField(
                    inscriptionController: inscriptionController,
                    inscriptionFocusNode: inscriptionFocusNode,
                    nameFocusNode: nameFocusNode,
                  ),
                ],
                gapH8,
                NameField(
                  nameController: nameController,
                  nameFocusNode: nameFocusNode,
                  reducedNameFocusNode: reducedNameFocusNode,
                ),
                gapH8,
                ReducedNameField(
                  reducedNameController: reducedNameController,
                  reducedNameFocusNode: reducedNameFocusNode,
                  passwordFocusNode: passwordFocusNode,
                ),
                gapH8,
                BirthDateField(
                  birthDateController: birthDateController,
                  birthDateFocusNode: birthDateFocusNode,
                ),
                gapH8,
                PasswordField(
                  passwordController: passwordController,
                  passwordFocusNode: passwordFocusNode,
                  passwordConfirmationFocusNode: passwordConfirmationFocusNode,
                ),
                gapH8,
                PasswordConfirmationField(
                  passwordController: passwordController,
                  passwordConfirmationController:
                      passwordConfirmationController,
                  passwordConfirmationFocusNode: passwordConfirmationFocusNode,
                ),
                AnimatedBuilder(
                  animation: cpfCnpjController,
                  builder: (_, _) {
                    if (cpfCnpjController.text.length == 11) {
                      return const Column(children: [gapH8, SexDropDown()]);
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
