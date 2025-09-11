import 'package:celta_intelligence/features/auth/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../constants/constants.dart';
import '../../../../routing/routing.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaQuery = MediaQuery.of(context);

    ref.listen(authStateControllerProvider, (previous, next) {
      next.showAlertDialogOnError(context);
      if (next.value == null) {
        context.goNamed(AppRoute.auth.name);
      }
    });
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        width: mediaQuery.size.width * 0.85,
        child: Column(
          children: [
            Expanded(child: SizedBox()),
            InkWell(
              onTap: () async {
                context.pop();
                await showAlertDialog(
                  context: context,
                  title: 'Sair'.hardcoded,
                  content: 'Tem certeza que deseja sair?'.hardcoded,
                  cancelActionText: 'Cancelar'.hardcoded,
                  onOkPressed: () async {
                    await ref
                        .read(authStateControllerProvider.notifier)
                        .logout();
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(Sizes.p8),
                child: Row(
                  children: [
                    Expanded(child: Text('Sair'.hardcoded)),
                    Icon(
                      defaultTargetPlatform == TargetPlatform.iOS
                          ? CupertinoIcons.power
                          : Icons.logout,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: ResponsiveScrollableWidget(
        child: Column(children: [Text('Home'.hardcoded)]),
      ),
    );
  }
}
