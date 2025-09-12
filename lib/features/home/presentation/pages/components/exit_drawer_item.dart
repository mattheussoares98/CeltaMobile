import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../auth/presentation/controllers/controllers.dart';
import 'components.dart';

class ExitDrawerItem extends ConsumerWidget {
  const ExitDrawerItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          onOkPressed: () async {
            await ref.read(authStateControllerProvider.notifier).logout();
          },
        );
      },
      materialIcon: Icons.logout,
      cupertinoIcon: CupertinoIcons.power,
    );
  }
}
