import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/user_session/user_session.dart';
import 'components.dart';

class ExitDrawerItem extends ConsumerWidget {
  const ExitDrawerItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    DeviceType deviceType;

    if (theme.platform == TargetPlatform.iOS) {
      deviceType = DeviceType.ios;
    } else if (theme.platform == TargetPlatform.android) {
      deviceType = DeviceType.android;
    } else if (theme.platform == TargetPlatform.macOS) {
      deviceType = DeviceType.macOS;
    } else if (theme.platform == TargetPlatform.windows) {
      deviceType = DeviceType.windows;
    } else {
      deviceType = DeviceType.web;
    }

    return DrawerItem(
      message: 'Sair',
      onTap: () async {
        await showAlertDialog(
          context: context,
          title: 'Sair'.hardcoded,
          content: 'Tem certeza que deseja sair?'.hardcoded,
          cancelActionText: 'Cancelar'.hardcoded,
          defaultActionText: 'Sim'.hardcoded,
          onOkPressed: () =>
              ref.read(userSessionProvider.notifier).logout(deviceType),
        );
      },
      materialIcon: Icons.logout,
      cupertinoIcon: CupertinoIcons.power,
    );
  }
}
