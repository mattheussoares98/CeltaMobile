import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/presentation/controllers/user_session/user_session.dart';
import 'components.dart';

class CompleteDrawer extends ConsumerWidget {
  const CompleteDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaQuery = MediaQuery.of(context);
    final exitHeight = 40.0;

    final userSession = ref.watch(userSessionProvider);

    return Drawer(
      width: min(mediaQuery.size.width * 0.85, 400),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              //to put the exit button in the end
              height: max(mediaQuery.size.height - exitHeight, exitHeight * 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CeltaImage(),
                  DrawerItem(
                    message: userSession.value?.user.name ?? "",
                    materialIcon: Icons.person,
                    cupertinoIcon: CupertinoIcons.person,
                    onTap: null,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: exitHeight,
              child: ExitDrawerItem(
                logout: ref.read(userSessionProvider.notifier).logout,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
