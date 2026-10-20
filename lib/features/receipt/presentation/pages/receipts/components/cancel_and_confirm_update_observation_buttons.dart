import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/receipt/presentation/controllers/controllers.dart';

class CancelAndConfirmUpdateObservationButtons extends ConsumerWidget {
  final int index;
  final TextEditingController observationsController;
  final VoidCallback? updateObservations;
  const CancelAndConfirmUpdateObservationButtons({
    super.key,
    required this.index,
    required this.observationsController,
    required this.updateObservations,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: PrimaryTextButton(
            text: context.l10n.cancel,
            onPressed: () {
              ref
                  .read(
                    selectedIndexUpdateObservationsStateControllerProvider
                        .notifier,
                  )
                  .updateSelectedIndex(index);

              observationsController.clear();
            },
          ),
        ),
        Expanded(
          child: PrimaryTextButton(
            text: context.l10n.confirmNote,
            onPressed: updateObservations,
          ),
        ),
      ],
    );
  }
}
