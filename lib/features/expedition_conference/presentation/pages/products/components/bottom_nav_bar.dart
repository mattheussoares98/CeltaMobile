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
    return BottomNavigationBar(
      currentIndex: ref.watch(pageIndexStateControllerProvider),
      onTap: ref.read(pageIndexStateControllerProvider.notifier).updateIndex,
      items: [
        BottomNavigationBarItem(
          label: 'Pendentes'.hardcoded,
          icon: Badge(
            label: Consumer(
              builder: (_, ref, _) {
                return Text(
                  ref
                      .watch(
                        expeditionConferenceControllerProvider(
                          expeditionControlCode,
                        ).select((s) => s.value?.pendingProducts.length ?? 0),
                      )
                      .toString(),
                );
              },
            ),
            offset: const Offset(8, -6),
            child: const PlatformIcon(
              cupertinoIcon: CupertinoIcons.exclamationmark_triangle,
              materialIcon: Icons.error,
            ),
          ),
        ),
        BottomNavigationBarItem(
          label: 'Conferidos'.hardcoded,
          icon: Badge(
            label: Consumer(
              builder: (_, ref, _) {
                return Text(
                  ref
                      .watch(
                        expeditionConferenceControllerProvider(
                          expeditionControlCode,
                        ).select((s) => s.value?.scannedProducts.length ?? 0),
                      )
                      .toString(),
                );
              },
            ),
            offset: const Offset(8, -6),
            child: const PlatformIcon(
              cupertinoIcon: CupertinoIcons.checkmark_seal,
              materialIcon: Icons.verified_rounded,
            ),
          ),
        ),
      ],
    );
  }
}
