import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';

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
          Text(
            'Nenhum produto foi encontrado'.hardcoded,
            textAlign: TextAlign.center,
          ),
          PrimaryTextButton(
            text: 'Pesquisar novamente'.hardcoded,
            icon: const PlatformIcon(
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
