import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../../domain/entity/entity.dart';
import '../../controllers/controllers.dart';

class ToggleUpdateObservationButton extends ConsumerWidget {
  final ReceiptEntity receipt;
  final int enterpriseCode;
  final int index;
  final TextEditingController observationsController;
  const ToggleUpdateObservationButton({
    super.key,
    required this.receipt,
    required this.enterpriseCode,
    required this.index,
    required this.observationsController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return PrimaryTextButton(
      text: 'Alterar'.hardcoded,
      isLoading: ref.watch(
        receiptsStateControllerProvider(
          enterpriseCode,
        ).select((s) => s.isLoading),
      ),
      onPressed: () {
        ref
            .read(selectedIndexUpdateCommnentStateControllerProvider.notifier)
            .update(index);

        observationsController.text =
            (receipt.Observacoes_ProcRecebDoc ??
                    receipt.DefaultObservations ??
                    '')
                .replaceAll(RegExp(r'\\r\\'), '')
                .replaceAll(RegExp(r'\\n'), '\n')
                .replaceAll(RegExp(r'\\'), '');
      },
      icon: Icon(isIOS ? CupertinoIcons.pencil : Icons.edit),
    );
  }
}
