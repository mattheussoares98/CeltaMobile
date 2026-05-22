import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/home/presentation/controllers/controllers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:celta_inventario/utils/utils.dart';

class FavoriteIconButton extends ConsumerWidget {
  const FavoriteIconButton({super.key, required this.module});

  final Modules module;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              ? PlatformIcon(
                  cupertinoIcon: CupertinoIcons.star_fill,
                  materialIcon: Icons.star,
                  color: context.theme.primaryColorDark,
                  size: 14,
                )
              : PlatformIcon(
                  cupertinoIcon: CupertinoIcons.star,
                  materialIcon: Icons.star_border,
                  color: context.theme.disabledColor,
                  size: 14,
                ),
        ),
      ),
    );
  }
}
