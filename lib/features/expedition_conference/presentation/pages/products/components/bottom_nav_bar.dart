import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../domain/entities/entities.dart';

class BottomNavBar extends StatelessWidget {
  final AsyncValue<ExpeditionConferenceState> pendingProductsAsync;
  final void Function(int) onTap;
  final int currentIndex;
  const BottomNavBar({
    super.key,
    required this.pendingProductsAsync,
    required this.onTap,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

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
            offset: Offset(8, -6),
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
            offset: Offset(8, -6),
            child: Icon(
              isIOS ? CupertinoIcons.checkmark_seal : Icons.verified_rounded,
            ),
          ),
        ),
      ],
    );
  }
}
