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
    final mediaSize = MediaQuery.sizeOf(context);
    final mediaPedding = MediaQuery.paddingOf(context);
    const exitHeight = 40.0;

    final userSession = ref.watch(userSessionProvider);

    return Drawer(
      width: min(mediaSize.width * 0.85, 400),
      child: Column(
        children: [
          const CeltaImage(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DrawerItem(
                    message: userSession.value?.user.name ?? "",
                    materialIcon: Icons.person,
                    cupertinoIcon: CupertinoIcons.person,
                    onTap: null,
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: exitHeight + mediaPedding.bottom,
            padding: EdgeInsets.only(bottom: mediaPedding.bottom),
            child: ExitDrawerItem(
              logout: ref.read(userSessionProvider.notifier).logout,
            ),
          ),
        ],
      ),
    );
  }
}
