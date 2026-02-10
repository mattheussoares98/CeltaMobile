import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'components.dart';

class CompleteDrawer extends ConsumerWidget {
  const CompleteDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaSize = MediaQuery.sizeOf(context);

    return Drawer(
      width: min(mediaSize.width * 0.85, 400),
      child: const SafeArea(
        child: Column(
          children: [
            Flexible(child: CeltaImage()),
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [UserNameDrawerItem()],
                ),
              ),
            ),
            ExitDrawerItem(),
          ],
        ),
      ),
    );
  }
}
