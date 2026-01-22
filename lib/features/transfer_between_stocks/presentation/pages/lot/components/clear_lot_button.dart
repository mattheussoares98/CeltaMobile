import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../controllers/controllers.dart';

class ClearLotButton extends ConsumerWidget {
  final int enterpriseCode;
  const ClearLotButton({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    final canShowClearLotButton = ref.watch(
      lotStateControllerProvider(
        enterpriseCode,
      ).select((s) => (s.value?.length ?? 0) > 3),
    );
    if (canShowClearLotButton) {
      return PrimaryTextButton(
        text: ''.hardcoded,
        color: Colors.red,
        icon: Icon(
          isIOS ? CupertinoIcons.delete : Icons.delete,
          color: Colors.red,
        ),
        onPressed: () {
          showAlertDialog(
            context: context,
            title: 'Limpar lote?'.hardcoded,
            cancelActionText: 'Cancelar'.hardcoded,
            defaultActionText: 'Limpar'.hardcoded,
            onOkPressed: () {
              ref
                  .read(lotStateControllerProvider(enterpriseCode).notifier)
                  .clearLot(enterpriseCode);
            },
          );
        },
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
