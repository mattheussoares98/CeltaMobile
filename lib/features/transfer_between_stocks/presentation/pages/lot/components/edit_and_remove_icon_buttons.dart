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
  const EditAndRemoveIconButtons({
    super.key,
    required this.item,
    required this.enterpriseCode,
    required this.onTapEdit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return Row(
      children: [
        IconButton(
          onPressed: onTapEdit,
          icon: Icon(isIOS ? CupertinoIcons.pencil : Icons.edit_outlined),
        ),
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
                    .removeItem(item);
              },
            );
          },
          icon: Icon(
            isIOS ? CupertinoIcons.delete : Icons.delete,
            color: Colors.red,
          ),
        ),
      ],
    );
  }
}
