import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/features/transfer_between_stocks/domain/entities/entities.dart';
import 'package:celta_inventario/features/transfer_between_stocks/presentation/controllers/controllers.dart';

class EditAndRemoveIconButtons extends ConsumerWidget {
  final ProductLotInfoEntity item;
  final int enterpriseCode;
  final VoidCallback onTapEdit;
  final int index;
  const EditAndRemoveIconButtons({
    super.key,
    required this.item,
    required this.enterpriseCode,
    required this.onTapEdit,
    required this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected =
        ref.watch(selectedLotIndexStateControllerProvider) == index;

    return Row(
      children: [
        IconButton(
          onPressed: () async {
            final confirmed = await showAlertDialog(
              context: context,
              title: 'Remover item?'.hardcoded,
              cancelActionText: 'Cancelar'.hardcoded,
              defaultActionText: 'Remover'.hardcoded,
            );

            if (confirmed != true || !context.mounted) return;
            ref
                .read(lotStateControllerProvider(enterpriseCode).notifier)
                .removeItem(item.product.ProductPackingCode!);
          },
          icon: const PlatformIcon(
            cupertinoIcon: CupertinoIcons.delete,
            materialIcon: Icons.delete,
            color: Colors.red,
          ),
        ),
        SelectedIconIndicator(selected: selected, onTap: onTapEdit),
      ],
    );
  }
}
