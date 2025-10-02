import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../commom_widgets/commom_widgets.dart';
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
  final nameFocusNode = FocusNode();
  final reducedNameFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final passwordConfirmationFocusNode = FocusNode();
  final personalPageFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    cpfCnpjController.dispose();
    nameController.dispose();
    reducedNameController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();
    nameFocusNode.dispose();
    reducedNameFocusNode.dispose();
    passwordFocusNode.dispose();
    passwordConfirmationFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIos = theme.platform == TargetPlatform.iOS;

    final customerAsync = ref.watch(customerStateControllerProvider);
    ref.listen(customerStateControllerProvider, (p, n) {
      n.doOnSuccess(p, () {
        nameController.text = n.value?.Name ?? '';
        reducedNameController.text = n.value?.ReducedName ?? '';
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
