import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/home/presentation/pages/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExitDrawerItem extends ConsumerWidget {
  const ExitDrawerItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DrawerItem(
      message: 'Sair',
      onTap: () async {
        final confirmed = await showAlertDialog(
          context: context,
          title: 'Sair'.hardcoded,
          content: 'Tem certeza que deseja sair?'.hardcoded,
          cancelActionText: 'Cancelar'.hardcoded,
          defaultActionText: 'Sim'.hardcoded,
        );

        if (confirmed != true || !context.mounted) return;
        ref.read(userSessionProvider.notifier).logout();
      },
      platformIcon: const PlatformIcon(
        cupertinoIcon: CupertinoIcons.power,
        materialIcon: Icons.logout,
      ),
    );
  }
}
