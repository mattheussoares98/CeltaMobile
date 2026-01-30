import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../domain/entities/entities.dart';
import '../../controllers/controllers.dart';

class ClearCartButton extends ConsumerWidget {
  final DraftKey draftKey;
  const ClearCartButton({super.key, required this.draftKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;
    final cartIsEmpty = ref.watch(
      cartProductsStateControllerProvider(
        draftKey,
      ).select((s) => s.value?.isEmpty ?? true),
    );
    final isDesktop = MediaQuery.sizeOf(context).width > Breakpoint.desktop;

    return PrimaryTextButton(
      text: isDesktop ? 'Limpar carrinho'.hardcoded : '',
      icon: Icon(
        isIOS ? CupertinoIcons.delete : Icons.delete,
        color: cartIsEmpty ? theme.disabledColor : Colors.red,
      ),
      color: Colors.red,
      onPressed: cartIsEmpty
          ? null
          : () {
              showAlertDialog(
                context: context,
                title: 'Limpar carrinho?'.hardcoded,
                defaultActionText: 'Limpar'.hardcoded,
                cancelActionText: 'Cancelar'.hardcoded,
                onOkPressed: () {
                  ref
                      .read(
                        cartProductsStateControllerProvider(draftKey).notifier,
                      )
                      .clearLot();
                },
              );
            },
    );
  }
}
