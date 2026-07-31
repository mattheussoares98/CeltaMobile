import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RereadActions extends ConsumerWidget {
  const RereadActions({
    super.key,
    required this.detailType,
    required this.onMarkAll,
    required this.onMarkSelected,
  });
  final SynchronizerErrorDetailType detailType;
  final VoidCallback onMarkAll;
  final VoidCallback onMarkSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(markSynchronizerItemsToReadAgainControllerProvider(detailType), (
      p,
      n,
    ) {
      n.showAlertDialogOnError(context);
    });
    ref.observeLoading([
      markSynchronizerItemsToReadAgainControllerProvider(detailType),
    ]);

    return Padding(
      padding: const EdgeInsets.all(Sizes.p8),
      child: Row(
        children: [
          Expanded(
            child: PrimaryButton(
              text: 'Marcar todos para releitura'.hardcoded,
              onPressed: onMarkAll,
            ),
          ),
          gapW8,
          Expanded(
            child: Consumer(
              builder: (_, ref, _) {
                final hasSelectedItems = ref.watch(
                  selectedSynchronizerCodesStateControllerProvider(
                    detailType,
                  ).select((s) => s.isNotEmpty),
                );

                return PrimaryButton(
                  text: 'Marcar selecionados para releitura'.hardcoded,
                  onPressed: hasSelectedItems ? onMarkSelected : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
