import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../core/presentation/controllers/app_version/app_version.dart';
import 'components.dart';

class CompleteDrawer extends ConsumerWidget {
  const CompleteDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaSize = MediaQuery.sizeOf(context);

    return Drawer(
      width: min(mediaSize.width * 0.85, 400),
      child: SafeArea(
        child: Column(
          children: [
            const Flexible(child: CeltaImage()),
            const Expanded(
              flex: 3,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [UserNameDrawerItem()],
                ),
              ),
            ),
            const ExitDrawerItem(),
            Consumer(
              builder: (context, ref, child) {
                return AsyncValueWidget(
                  value: ref.watch(appVersionStateControllerProvider),
                  tryAgain: () =>
                      ref.invalidate(appVersionStateControllerProvider),
                  data: (version) {
                    return Text('Versão $version');
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
