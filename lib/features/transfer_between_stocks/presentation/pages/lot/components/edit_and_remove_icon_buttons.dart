import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../../domain/entities/entities.dart';
import '../../../controllers/controllers.dart';

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
          onPressed: () {
            showAlertDialog(
              context: context,
              title: 'Remover item?'.hardcoded,
              cancelActionText: 'Cancelar'.hardcoded,
              defaultActionText: 'Remover'.hardcoded,
              onOkPressed: () {
                ref
                    .read(lotStateControllerProvider(enterpriseCode).notifier)
                    .removeItem(item.product.ProductPackingCode!);
              },
            );
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
