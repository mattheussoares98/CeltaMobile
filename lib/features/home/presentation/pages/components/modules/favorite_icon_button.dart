import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/domain/entities/entities.dart';
import '../../../controllers/controllers.dart';

class FavoriteIconButton extends ConsumerWidget {
  const FavoriteIconButton({super.key, required this.module});

  final Modules module;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    final isFavorite = ref.watch(
      favoriteModulesStateControllerProvider.select(
        (s) => s.value?.contains(module) ?? false,
      ),
    );

    return Positioned(
      top: 0,
      right: 0,
      child: RepaintBoundary(
        child: IconButton(
          onPressed: () => ref
              .read(favoriteModulesStateControllerProvider.notifier)
              .toggle(module),
          icon: isFavorite
              ? Icon(
                  isIOS ? CupertinoIcons.star_fill : Icons.star,
                  color: theme.primaryColorDark,
                  size: 14,
                )
              : Icon(
                  isIOS ? CupertinoIcons.star : Icons.star_border,
                  color: theme.disabledColor,
                  size: 14,
                ),
        ),
      ),
    );
  }
}
