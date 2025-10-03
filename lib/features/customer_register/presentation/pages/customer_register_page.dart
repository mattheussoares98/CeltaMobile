import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../core/validators/validators.dart';
import '../controllers/controllers.dart';
import 'pages.dart';

class CustomerRegisterPage extends ConsumerStatefulWidget {
  const CustomerRegisterPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CustomerRegisterPageState();
}

class _CustomerRegisterPageState extends ConsumerState<CustomerRegisterPage> {
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
  String? selectedSex;

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
    reducedNameFocusNode.dispose();
    passwordFocusNode.dispose();
    passwordConfirmationFocusNode.dispose();
    birthDateFocusNode.dispose();
    inscriptionFocusNode.dispose();
  }

  void clearAllFields() {
    nameController.clear();
    reducedNameController.clear();
    passwordController.clear();
    passwordConfirmationController.clear();
    birthDateController.clear();
  }

  Future<void> onChangeCpfCnpj() async {
    if (CpfCnpjValidator().isValid(cpfCnpjController.text)) {
      clearAllFields();

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
      cpfCnpjController.text = customer.CpfCnpjNumber ?? '';
      inscriptionController.text = customer.RegistrationNumber ?? '';
      nameController.text = customer.Name ?? '';
      reducedNameController.text = customer.ReducedName ?? '';

      if (customer.DateOfBirth != null) {
        final day = customer.DateOfBirth!.day.toString().padLeft(2, '0');
        final month = customer.DateOfBirth!.month.toString().padLeft(2, '0');
        final year = customer.DateOfBirth!.year.toString().padLeft(4, '0');
        birthDateController.text = '$day/$month/$year';
      }
      setState(() {});
    }
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
          setState(() {
            selectedSex = sex;
          });
        },
        selectedSex: selectedSex,
      ),
      AddressPage(),
      EmailPage(),
      PhonePage(),
      CovenantsPage(),
      SavePage(),
    ];

    return Stack(
      children: [
        Scaffold(
          body: pages[selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            unselectedFontSize: 11,
            selectedFontSize: 11,
            currentIndex: selectedIndex,
            onTap: (index) {
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
                icon: Icon(isIos ? CupertinoIcons.location : Icons.location_on),
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
        if (customerAsync.isLoading) LoadingPage(),
      ],
    );
  }
}
