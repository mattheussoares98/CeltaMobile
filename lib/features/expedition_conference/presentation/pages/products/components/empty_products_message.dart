import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmptyProductsMessage extends ConsumerWidget {
  final VoidCallback onRefreshEmptyProducts;
  const EmptyProductsMessage({super.key, required this.onRefreshEmptyProducts});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(Sizes.p8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BaseText.error(
            context.l10n.noProductsFound,
            textAlign: TextAlign.center,
          ),
          gapH8,
          PrimaryTextButton(
            text: context.l10n.searchAgain,
            platformIcon: const PlatformIcon(
              cupertinoIcon: CupertinoIcons.refresh,
              materialIcon: Icons.refresh_rounded,
            ),
            onPressed: onRefreshEmptyProducts,
          ),
        ],
      ),
    );
  }
}
