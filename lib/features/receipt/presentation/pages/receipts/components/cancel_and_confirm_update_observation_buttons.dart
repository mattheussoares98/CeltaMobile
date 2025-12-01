import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../controllers/controllers.dart';

class CancelAndConfirmUpdateObservationButtons extends ConsumerWidget {
  final int index;
  final TextEditingController observationsController;
  final VoidCallback updateObservations;
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
            text: 'Cancelar'.hardcoded,
            onPressed: () {
              ref
                  .read(
                    selectedIndexUpdateCommnentStateControllerProvider.notifier,
                  )
                  .update(index);

              observationsController.clear();
            },
          ),
        ),
        Expanded(
          child: PrimaryTextButton(
            text: 'Confirmar obs'.hardcoded,
            onPressed: updateObservations,
          ),
        ),
      ],
    );
  }
}
