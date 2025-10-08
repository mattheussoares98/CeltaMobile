import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../core/domain/entities/entities.dart';
import '../../../../core/validators/validators.dart';
import '../../../enterprises/presentation/controllers/controllers.dart';
import '../controllers/controllers.dart';
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
  BrazilStates? state;
  final numberFocusNode = FocusNode();
  final complementFocusNode = FocusNode();
  final referenceFocusNode = FocusNode();
  final zipFocusNode = FocusNode();
  List<AddressEntity> addressess = [];
  final addressFormKey = GlobalKey<FormState>(); //TODO remove from here
  bool showAddressFields = false;
  //! address

  //! emails
  List<String> emails = [];
  final emailController = TextEditingController();
  final emailFormKey = GlobalKey<FormState>();
  //! emails

  //! phone
  final dddController = TextEditingController();
  final phoneController = TextEditingController();
  final phoneFocusNode = FocusNode();
  final phoneFormKey = GlobalKey<FormState>(); //TODO remove from here
  List<CustomerTelephoneEntity> phones = [];
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
    addressFormKey.currentState?.dispose();
    //! address

    //! emails
    emailController.dispose();
    emailFormKey.currentState?.dispose();
    //! emails

    //! phone
    dddController.dispose();
    phoneController.dispose();
    phoneFocusNode.dispose();
    phoneFormKey.currentState?.dispose();
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

      //! address
      addressess = [...?customer.Addresses];
      final address = await ref.read(getAddressByCepControllerProvider.future);
      if (address != null) {
        showAddressFields = true;
      }
      zipController.text = address?.Zip.replaceAll(RegExp(r'-'), '') ?? '';
      addressController.text = address?.Address ?? '';
      districtController.text = address?.District ?? '';
      cityController.text = address?.City ?? '';

      final stateIndex = BrazilStates.values.indexWhere(
        (e) => e.name == address?.State,
      );
      if (stateIndex != -1) {
        state = BrazilStates.values[stateIndex];
      }
      //! address

      //! emails
      emails = [...?customer.Emails];
      //! emails

      //! phone
      phones = [...?customer.Telephones];
      //! phone
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIos = theme.platform == TargetPlatform.iOS;

    final customerAsync = ref.watch(customerStateControllerProvider);
    ref.listen(customerStateControllerProvider, (p, n) {
      n.doOnSuccess(p, () {
        updateFields();
      });
    });

    final selectedEnterprise = ref.watch(
      selectedEnterpriseStateControllerProvider,
    );
    final covenantsAsync = ref.watch(
      covenantsStateControllerProvider(
        selectedEnterprise!,
      ), //only achieves here if has a selected enterprise
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
      AddressPage(
        formKey: addressFormKey,
        zipController: zipController,
        numberController: numberController,
        addressController: addressController,
        districtController: districtController,
        cityController: cityController,
        complementController: complementController,
        referenceController: referenceController,
        state: state,
        numberFocusNode: numberFocusNode,
        complementFocusNode: complementFocusNode,
        referenceFocusNode: referenceFocusNode,
        zipFocusNode: zipFocusNode,
        addressess: addressess,
        showAddressFields: showAddressFields,
        changeShowAllFields: (value) {
          setState(() {
            showAddressFields = value;
          });
        },
        removeAddress: (index) {
          setState(() {
            addressess.removeAt(index);
          });
        },
        addAddress: () {
          setState(() {
            addressess.add(
              AddressEntity(
                Zip: zipController.text,
                Address: addressController.text,
                Number: numberController.text,
                District: districtController.text,
                City: cityController.text,
                State: state?.name,
                Complement: complementController.text,
                Reference: referenceController.text,
              ),
            );
          });
        },
        onChangeState: (value) {
          setState(() {
            state = value;
          });
        },
      ),
      EmailPage(
        emails: emails,
        emailController: emailController,
        formKey: emailFormKey,
        removeEmail: (index) {
          setState(() {
            emails.removeAt(index);
          });
        },
        addEmail: () {
          setState(() {
            emails.add(emailController.text);
            emailController.clear();
          });
        },
      ),
      PhonePage(
        phones: phones,
        dddController: dddController,
        phoneController: phoneController,
        phoneFocusNode: phoneFocusNode,
        formKey: phoneFormKey,
        addPhone: () {
          setState(() {
            phones.add(
              CustomerTelephoneEntity(
                AreaCode: dddController.text,
                PhoneNumber: phoneController.text,
              ),
            );
          });

          dddController.clear();
          phoneController.clear();
        },
        removePhone: (index) {
          setState(() {
            phones.removeAt(index);
          });
        },
      ),
      CovenantsPage(
        covenantsAsync: covenantsAsync,
        limitController: limitController,
        limitFocusNode: limitFocusNode,
        bindedCovenants: [...?customerAsync.value?.CustomerCovenants],
        customer: customerAsync.value,
      ),
      SavePage(),
    ];

    return Stack(
      children: [
        PopScope(
          onPopInvokedWithResult: (didPop, result) async {
            final customer = await ref.read(
              customerStateControllerProvider.future,
            );
            if (customer != null) {
              ref
                  .read(customerStateControllerProvider.notifier)
                  .updateCustomer(
                    customer.copyWith(
                      CpfCnpjNumber: cpfCnpjController.text,
                      PersonType: selectedSex?.name,
                      SexType: selectedSex,
                      RegistrationNumber: inscriptionController.text,
                      Name: nameController.text,
                      ReducedName: reducedNameController.text,
                      DateOfBirth: DateFormat(
                        'dd/MM/yyyy',
                      ).tryParse(birthDateController.text),
                      Addresses: addressess,
                      Emails: emails,
                      Telephones: phones,
                    ),
                  );
            }
          },
          child: Scaffold(
            body: pages[selectedIndex],
            bottomNavigationBar: BottomNavigationBar(
              unselectedFontSize: 11,
              selectedFontSize: 11,
              currentIndex: selectedIndex,
              onTap: (index) {
                if (selectedIndex == 0 &&
                    personalPageFormKey.currentState?.validate() != true) {
                  return;
                }
                setState(() {
                  selectedIndex = index;
                });
              },
              items: [
                BottomNavigationBarItem(
                  label: 'Dados'.hardcoded,
                  icon: Icon(isIos ? CupertinoIcons.person : Icons.person),
                ),
                BottomNavigationBarItem(
                  label: 'Endereço'.hardcoded,
                  icon: Icon(
                    isIos ? CupertinoIcons.location : Icons.location_on,
                  ),
                ),
                BottomNavigationBarItem(
                  label: 'E-mail'.hardcoded,
                  icon: Icon(isIos ? CupertinoIcons.mail : Icons.email),
                ),
                BottomNavigationBarItem(
                  label: 'Telefone'.hardcoded,
                  icon: Icon(isIos ? CupertinoIcons.phone : Icons.phone),
                ),
                BottomNavigationBarItem(
                  label: 'Convênios'.hardcoded,
                  icon: Icon(isIos ? CupertinoIcons.creditcard : Icons.wallet),
                ),
                BottomNavigationBarItem(
                  label: 'Salvar'.hardcoded,
                  icon: Icon(isIos ? CupertinoIcons.check_mark : Icons.save),
                ),
              ],
            ),
          ),
        ),
        if (customerAsync.isLoading) LoadingPage(),
      ],
    );
  }
}
