import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/transfer_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/transfer_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RemoveAndEditIcons extends ConsumerWidget {
  final DraftKey draftKey;
  final TransferRequestProductItemEntity item;
  final VoidCallback changeSelectedIndex;
  const RemoveAndEditIcons({
    super.key,
    required this.draftKey,
    required this.item,
    required this.changeSelectedIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        IconButton(
          onPressed: () async {
            final confirmed = await showAlertDialog(
              context: context,
              title: context.l10n.removeItem,
              cancelActionText: context.l10n.cancel,
              defaultActionText: context.l10n.remove,
            );

            if (confirmed != true || !context.mounted) return;
            ref
                .read(cartProductsStateControllerProvider(draftKey).notifier)
                .removeItem(item);
          },
          icon: const PlatformIcon(
            cupertinoIcon: CupertinoIcons.delete,
            materialIcon: Icons.delete,
            color: Colors.red,
          ),
        ),
        PrimaryTextButton(
          text: PlatformUtil.isCupertino ? context.l10n.edit : '',
          onPressed: changeSelectedIndex,
          platformIcon: const PlatformIcon(
            cupertinoIcon: CupertinoIcons.pencil,
            materialIcon: Icons.edit,
          ),
        ),
      ],
    );
  }
}
