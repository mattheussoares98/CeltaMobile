import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/transfer_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/transfer_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClearCartButton extends ConsumerWidget {
  final DraftKey draftKey;
  const ClearCartButton({super.key, required this.draftKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartIsEmpty = ref.watch(
      cartProductsStateControllerProvider(
        draftKey,
      ).select((s) => s.value?.isEmpty ?? true),
    );
    final isDesktop = MediaQuery.sizeOf(context).width > Breakpoint.desktop;

    return PrimaryTextButton(
      text: isDesktop ? 'Limpar carrinho'.hardcoded : '',
      platformIcon: PlatformIcon(
        cupertinoIcon: CupertinoIcons.delete,
        materialIcon: Icons.delete,
        color: cartIsEmpty ? context.theme.disabledColor : Colors.red,
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
