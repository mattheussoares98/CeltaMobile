import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controllers/controllers.dart';

class BottomNavBar extends ConsumerWidget {
  final void Function(int) onTap;
  final int currentIndex;
  final int expeditionControlCode;
  const BottomNavBar({
    super.key,
    required this.onTap,
    required this.currentIndex,
    required this.expeditionControlCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    final pendingProductsAsync = ref.watch(
      expeditionConferenceControllerProvider(expeditionControlCode),
    );

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(
          label: 'Pendentes'.hardcoded,
          icon: Badge(
            label: Text(
              pendingProductsAsync.value?.pendingProducts.length.toString() ??
                  '0',
            ),
            offset: const Offset(8, -6),
            child: Icon(
              isIOS ? CupertinoIcons.exclamationmark_triangle : Icons.error,
            ),
          ),
        ),
        BottomNavigationBarItem(
          label: 'Conferidos'.hardcoded,
          icon: Badge(
            label: Text(
              pendingProductsAsync.value?.scannedProducts.length.toString() ??
                  '0',
            ),
            offset: const Offset(8, -6),
            child: Icon(
              isIOS ? CupertinoIcons.checkmark_seal : Icons.verified_rounded,
            ),
          ),
        ),
      ],
    );
  }
}
