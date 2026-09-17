import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/enterprise_manager/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LogoutButton extends ConsumerWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () async {
        final confirmed = await showAlertDialog(
          context: context,
          title: "Sair".hardcoded,
          cancelActionText: "Cancelar".hardcoded,
          defaultActionText: "Sair".hardcoded,
          content: "Tem certeza que deseja sair?".hardcoded,
        );

        if (confirmed != true || !context.mounted) return;
        ref.read(authManagerControllerProvider.notifier).logout();
        context.pop();
      },
      icon: Icon(
        PlatformUtil.isCupertino
            ? CupertinoIcons.person_crop_circle_badge_xmark
            : Icons.logout,
      ),
    );
  }
}
