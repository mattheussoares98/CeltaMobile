import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectableActions extends ConsumerWidget {
  const SelectableActions({
    super.key,
    required this.detailType,
    required this.selectableItems,
    required this.errorKey,
  });
  final SynchronizerErrorDetailType detailType;
  final List<SelectableSynchronizerErrorDetailEntity> selectableItems;
  final String errorKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onTap(List<int> codes) {
      switch (detailType) {
        case SynchronizerErrorDetailType.couponMarkedToReadAgain:
          ref
              .read(
                markSynchronizerItemsToReadAgainControllerProvider(
                  detailType,
                ).notifier,
              )
              .markToReadAgain(codes, errorKey);
          break;
        case SynchronizerErrorDetailType.schedule:
          ref
              .read(deleteScheduleErrorsControllerProvider.notifier)
              .delete(codes, errorKey);
          break;
        default:
      }
    }

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
              text: switch (detailType) {
                SynchronizerErrorDetailType.couponMarkedToReadAgain =>
                  'Marcar todos para releitura'.hardcoded,
                SynchronizerErrorDetailType.schedule =>
                  'Excluir todos'.hardcoded,
                _ => 'BUG. Não implementado'.hardcoded,
              },
              onPressed: () {
                onTap(selectableItems.map((e) => e.code).toList());
              },
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
                  text: switch (detailType) {
                    SynchronizerErrorDetailType.couponMarkedToReadAgain =>
                      'Marcar selecionados para releitura'.hardcoded,
                    SynchronizerErrorDetailType.schedule =>
                      'Excluir selecionados'.hardcoded,
                    _ => 'BUG. Não implementado'.hardcoded,
                  },

                  onPressed: hasSelectedItems
                      ? () {
                          onTap(
                            ref.read(
                              selectedSynchronizerCodesStateControllerProvider(
                                detailType,
                              ),
                            ),
                          );
                        }
                      : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
