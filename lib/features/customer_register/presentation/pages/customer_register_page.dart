import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pages.dart';

class CustomerRegisterPage extends ConsumerStatefulWidget {
  const CustomerRegisterPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CustomerRegisterPageState();
}

class _CustomerRegisterPageState extends ConsumerState<CustomerRegisterPage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIos = theme.platform == TargetPlatform.iOS;

    final pages = [
      PersonalDataPage(),
      AddressPage(),
      EmailPage(),
      PhonePage(),
      CovenantsPage(),
      SavePage(),
    ];

    return Scaffold(
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
    );
  }
}
