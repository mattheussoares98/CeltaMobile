import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/expedition_conference/presentation/controllers/controllers.dart';

class BottomNavBar extends ConsumerWidget {
  final int expeditionControlCode;
  const BottomNavBar({super.key, required this.expeditionControlCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingCount = ref.watch(
      expeditionConferenceControllerProvider(
        expeditionControlCode,
      ).select((s) => s.value?.pendingProducts.length ?? 0),
    );

    final scannedCount = ref.watch(
      expeditionConferenceControllerProvider(
        expeditionControlCode,
      ).select((s) => s.value?.scannedProducts.length ?? 0),
    );

    return DefaultBottomNavigationBar(
      currentIndex: ref.watch(pageIndexStateControllerProvider),
      onTap: ref.read(pageIndexStateControllerProvider.notifier).updateIndex,
      items: [
        DefaultBottomNavigationBarItem(
          label: 'Pendentes'.hardcoded,
          badgeLabel: pendingCount.toString(),
          platformIcon: const PlatformIcon(
            cupertinoIcon: CupertinoIcons.exclamationmark_triangle,
            materialIcon: Icons.error,
          ),
        ),
        DefaultBottomNavigationBarItem(
          label: 'Conferidos'.hardcoded,
          badgeLabel: scannedCount.toString(),
          platformIcon: const PlatformIcon(
            cupertinoIcon: CupertinoIcons.checkmark_seal,
            materialIcon: Icons.verified_rounded,
          ),
        ),
      ],
    );
  }
}
