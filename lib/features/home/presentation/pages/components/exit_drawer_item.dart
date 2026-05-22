import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/home/presentation/pages/components/components.dart';
import 'package:celta_inventario/utils/utils.dart';

class ExitDrawerItem extends ConsumerWidget {
  const ExitDrawerItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    DeviceType deviceType;

    if (PlatformUtil.isCupertino) {
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
      platformIcon: const PlatformIcon(
        cupertinoIcon: CupertinoIcons.power,
        materialIcon: Icons.logout,
      ),
    );
  }
}
