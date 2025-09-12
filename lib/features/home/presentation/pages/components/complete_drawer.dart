import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../auth/presentation/controllers/controllers.dart';
import 'components.dart';

class CompleteDrawer extends ConsumerWidget {
  const CompleteDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaQuery = MediaQuery.of(context);
    final exitHeight = 40.0;
    return Drawer(
      width: mediaQuery.size.width * 0.85,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              //to put the exit button in the end
              height: max(mediaQuery.size.height - exitHeight, exitHeight * 2),
            ),
            SizedBox(
              height: exitHeight,
              child: ExitDrawerItem(
                logout: ref.read(authStateControllerProvider.notifier).logout,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
