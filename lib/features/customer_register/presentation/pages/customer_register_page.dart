import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../core/domain/entities/entities.dart';
import '../../../../core/validators/validators.dart';
import '../../../enterprises/presentation/controllers/controllers.dart';
import '../controllers/controllers.dart';
import 'components/components.dart';
import 'pages.dart';

class CustomerRegisterPage extends ConsumerStatefulWidget {
  const CustomerRegisterPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CustomerRegisterPageState();
}

class _CustomerRegisterPageState extends ConsumerState<CustomerRegisterPage> {
  //! personal data
  int selectedIndex = 0;
  final cpfCnpjController = TextEditingController();
  final nameController = TextEditingController();
  final reducedNameController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();
  final birthDateController = TextEditingController();
  final inscriptionController = TextEditingController();
  final nameFocusNode = FocusNode();
  final reducedNameFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final passwordConfirmationFocusNode = FocusNode();
  final birthDateFocusNode = FocusNode();
  final inscriptionFocusNode = FocusNode();
  final personalPageFormKey = GlobalKey<FormState>();
  CustomerSexType? selectedSex;
  //! personal data

  //! address
  final addressPageFormKey = GlobalKey<FormState>();
  final zipController = TextEditingController();
  final numberController = TextEditingController();
  final addressController = TextEditingController();
  final districtController = TextEditingController();
  final cityController = TextEditingController();
  final complementController = TextEditingController();
  final referenceController = TextEditingController();
  final numberFocusNode = FocusNode();
  final complementFocusNode = FocusNode();
  final referenceFocusNode = FocusNode();
  final zipFocusNode = FocusNode();
  //! address

  //! emails
  final emailController = TextEditingController();
  final emailFormKey = GlobalKey<FormState>();
  //! emails

  //! phone
  final dddController = TextEditingController();
  final phoneController = TextEditingController();
  final phoneFocusNode = FocusNode();
  //! phone

  //! covenants
  final limitController = TextEditingController();
  final limitFocusNode = FocusNode();
  //! covenants

  @override
  void dispose() async {
    super.dispose();
    //! personal data
    cpfCnpjController.dispose();
    nameController.dispose();
    reducedNameController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();
    birthDateController.dispose();
    inscriptionController.dispose();
    nameFocusNode.dispose();
    reducedNameFocusNode.dispose();
    passwordFocusNode.dispose();
    passwordConfirmationFocusNode.dispose();
    birthDateFocusNode.dispose();
    inscriptionFocusNode.dispose();
    personalPageFormKey.currentState?.dispose();
    //! personal data

    //! address
    zipController.dispose();
    numberController.dispose();
    addressController.dispose();
    districtController.dispose();
    cityController.dispose();
    complementController.dispose();
    referenceController.dispose();
    numberFocusNode.dispose();
    complementFocusNode.dispose();
    referenceFocusNode.dispose();
    zipFocusNode.dispose();
    //! address

    //! emails
    emailController.dispose();
    emailFormKey.currentState?.dispose();
    //! emails

    //! phone
    dddController.dispose();
    phoneController.dispose();
    phoneFocusNode.dispose();
    //! phone

    //! covenants
    limitController.dispose();
    limitFocusNode.dispose();
    //! covenants
  }

  Future<void> onChangeCpfCnpj() async {
    if (CpfCnpjValidator().isValid(cpfCnpjController.text)) {
      await ref
          .read(customerStateControllerProvider.notifier)
          .loadCustomer(cpfCnpjController.text);
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await updateFields();
    });
  }

  void clearFields() {
    cpfCnpjController.clear();
    inscriptionController.clear();
    nameController.clear();
    reducedNameController.clear();
    birthDateController.clear();
    passwordController.clear();
    passwordConfirmationController.clear();
    selectedSex = null;
    setState(() {});
  }

  Future<void> updateFields() async {
    final customer = await ref.read(customerStateControllerProvider.future);
    if (customer != null) {
      //! personal data
      if (customer.CpfCnpjNumber != null) {
        cpfCnpjController.text = customer.CpfCnpjNumber!;
      }
      inscriptionController.text = customer.RegistrationNumber ?? '';
      nameController.text = customer.Name ?? '';
      reducedNameController.text = customer.ReducedName ?? '';
      passwordController.text = customer.Password ?? '';
      passwordConfirmationController.text = customer.Password ?? '';

      if (customer.DateOfBirth != null) {
        final day = customer.DateOfBirth!.day.toString().padLeft(2, '0');
        final month = customer.DateOfBirth!.month.toString().padLeft(2, '0');
        final year = customer.DateOfBirth!.year.toString().padLeft(4, '0');
        birthDateController.text = '$day/$month/$year';
      } else {
        birthDateController.text = '';
      }
      selectedSex = customer.SexType;
      //! personal data
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final customerAsync = ref.watch(customerStateControllerProvider);
    ref.listen(customerStateControllerProvider, (p, n) {
      n.doOnSuccess(p, () {
        updateFields();
      });
    });

    final insertUpdateAsync = ref.watch(insertUpdateCustomerControllerProvider);
    ref.listen(insertUpdateCustomerControllerProvider, (p, n) {
      n.doOnSuccess(p, () async {
        showSnackBarMessage(
          context,
          'Cliente cadastrado/atualizado com sucesso'.hardcoded,
        );
        ref.read(customerStateControllerProvider.notifier).updateCustomer(null);
        clearFields();
        setState(() {
          selectedIndex = 0;
        });
      });
      n.showAlertDialogOnError(context);
    });

    final selectedEnterprise = ref.watch(
      selectedEnterpriseStateControllerProvider,
    );
    final covenantsAsync = ref.watch(
      covenantsStateControllerProvider(
        selectedEnterprise!,
      ), //only achieves here if has a selected enterprise
    );

    final addressPage = AddressPage(
      customer: customerAsync.value,
      zipController: zipController,
      numberController: numberController,
      addressController: addressController,
      districtController: districtController,
      cityController: cityController,
      complementController: complementController,
      referenceController: referenceController,
      numberFocusNode: numberFocusNode,
      complementFocusNode: complementFocusNode,
      referenceFocusNode: referenceFocusNode,
      zipFocusNode: zipFocusNode,
    );

    final pages = [
      PersonalDataPage(
        formKey: personalPageFormKey,
        customer: customerAsync.value,
        cpfCnpjController: cpfCnpjController,
        nameController: nameController,
        reducedNameController: reducedNameController,
        passwordController: passwordController,
        passwordConfirmationController: passwordConfirmationController,
        nameFocusNode: nameFocusNode,
        reducedNameFocusNode: reducedNameFocusNode,
        passwordFocusNode: passwordFocusNode,
        passwordConfirmationFocusNode: passwordConfirmationFocusNode,
        onChangeCpfCnpj: onChangeCpfCnpj,
        birthDateController: birthDateController,
        birthDateFocusNode: birthDateFocusNode,
        inscriptionController: inscriptionController,
        inscriptionFocusNode: inscriptionFocusNode,
        onChangeSex: (sex) {
          selectedSex = sex;
        },
        selectedSex: selectedSex,
      ),
      addressPage,
      EmailPage(
        emailController: emailController,
        formKey: emailFormKey,
        customer: customerAsync.value,
      ),
      PhonePage(
        dddController: dddController,
        phoneController: phoneController,
        phoneFocusNode: phoneFocusNode,
        customer: customerAsync.value,
      ),
      CovenantsPage(
        covenantsAsync: covenantsAsync,
        limitController: limitController,
        limitFocusNode: limitFocusNode,
        customer: customerAsync.value,
      ),
      SavePage(
        customer: customerAsync.value,
        passwordController: passwordController,
        addressPage: addressPage,
      ),
    ];

    return Stack(
      children: [
        Scaffold(
          body: pages[selectedIndex],
          bottomNavigationBar: BottomNavigationWidget(
            customer: customerAsync.value,
            selectedIndex: selectedIndex,
            onTapItem: (index) {
              if (selectedIndex == 0 &&
                  personalPageFormKey.currentState?.validate() != true) {
                return;
              }

              if (customerAsync.value != null) {
                ref
                    .read(customerStateControllerProvider.notifier)
                    .updateCustomer(
                      customerAsync.value!.copyWith(
                        CpfCnpjNumber: cpfCnpjController.text,
                        PersonType: cpfCnpjController.text.length == 11
                            ? CustomerPersonType.fisica
                            : CustomerPersonType.juridica,
                        SexType: selectedSex,
                        RegistrationNumber: inscriptionController.text,
                        Name: nameController.text,
                        ReducedName: reducedNameController.text,
                        Password: passwordController.text,
                        DateOfBirth: DateFormat(
                          'dd/MM/yyyy',
                        ).tryParse(birthDateController.text),
                      ),
                    );
              }

              setState(() {
                selectedIndex = index;
              });
            },
          ),
        ),
        if (customerAsync.isLoading || insertUpdateAsync.isLoading)
          LoadingPage(),
      ],
    );
  }
}
