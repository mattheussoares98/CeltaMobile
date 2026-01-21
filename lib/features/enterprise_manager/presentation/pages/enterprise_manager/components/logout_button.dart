import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../providers.dart';

class LogoutButton extends ConsumerWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return IconButton(
      onPressed: () {
        showAlertDialog(
          context: context,
          title: "Sair".hardcoded,
          cancelActionText: "Cancelar".hardcoded,
          defaultActionText: "Sair".hardcoded,
          content: "Tem certeza que deseja sair?".hardcoded,
          onOkPressed: () {
            ref.read(authManagerRepositoryProvider).logout();
            context.pop();
          },
        );
      },
      icon: Icon(
        theme.platform == TargetPlatform.iOS
            ? CupertinoIcons.person_crop_circle_badge_xmark
            : Icons.logout,
      ),
    );
  }
}
