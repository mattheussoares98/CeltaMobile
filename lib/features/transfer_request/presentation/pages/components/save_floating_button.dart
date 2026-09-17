import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/transfer_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/transfer_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SaveFloatingButton extends ConsumerWidget {
  final DraftKey draftKey;
  const SaveFloatingButton({super.key, required this.draftKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartIsEmpty = ref.watch(
      cartProductsStateControllerProvider(
        draftKey,
      ).select((s) => s.value?.isEmpty ?? true),
    );

    return FloatingActionButton(
      backgroundColor: cartIsEmpty
          ? Colors.grey
          : context.theme.primaryColor.withAlpha(170),
      onPressed: cartIsEmpty
          ? null
          : () async {
              final confirmed = await showAlertDialog(
                context: context,
                title: 'Salvar pedido?'.hardcoded,
                cancelActionText: 'Cancelar'.hardcoded,
                defaultActionText: 'Sim'.hardcoded,
              );

              if (confirmed != true || !context.mounted) return;
              ref
                  .read(
                    insertTransferRequestControllerProvider(draftKey).notifier,
                  )
                  .insert();
            },
      child: const PlatformIcon(
        cupertinoIcon: CupertinoIcons.check_mark,
        materialIcon: Icons.save_rounded,
        color: Colors.white,
      ),
    );
  }
}
