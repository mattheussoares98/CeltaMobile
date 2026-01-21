import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../domain/entities/entities.dart';
import '../../../../controllers/controllers.dart';

class RemoveAndEditIcons extends ConsumerWidget {
  final DraftKey draftKey;
  final TransferRequestProductItemEntity item;
  const RemoveAndEditIcons({
    super.key,
    required this.draftKey,
    required this.item,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;
    return Column(
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
                    .read(
                      cartProductsStateControllerProvider(draftKey).notifier,
                    )
                    .removeItem(item);
              },
            );
          },
          icon: Icon(
            isIOS ? CupertinoIcons.delete : Icons.delete,
            color: Colors.red,
          ),
        ),
        Icon(isIOS ? CupertinoIcons.pencil : Icons.edit),
      ],
    );
  }
}
