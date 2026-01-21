import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import 'components.dart';

class ExitDrawerItem extends StatelessWidget {
  final VoidCallback logout;
  const ExitDrawerItem({super.key, required this.logout});

  @override
  Widget build(BuildContext context) {
    return DrawerItem(
      message: 'Sair',
      onTap: () async {
        context.pop();
        await showAlertDialog(
          context: context,
          title: 'Sair'.hardcoded,
          content: 'Tem certeza que deseja sair?'.hardcoded,
          cancelActionText: 'Cancelar'.hardcoded,
          defaultActionText: 'Sim'.hardcoded,
          onOkPressed: logout,
        );
      },
      materialIcon: Icons.logout,
      cupertinoIcon: CupertinoIcons.power,
    );
  }
}
