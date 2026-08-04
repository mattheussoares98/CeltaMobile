import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/resource/resource.dart';
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
    final canProceed = switch (detailType) {
      SynchronizerErrorDetailType.schedule => ref.watch(
        canAccessResourceStateControllerProvider(
          BsRoutine.generic,
          BsResource.synchronizerDelete,
        ).select((s) => s.value == true),
      ),
      _ => true,
    };

    void onTap(Set<int> codes) {
      if (!canProceed) {
        showAlertDialog(
          context: context,
          title: 'Atenção'.hardcoded,
          content:
              'Seu usuário não possui permissão para realizar esse procedimento'
                  .hardcoded,
        );
        return;
      }

      ref
          .read(handleSelectedCodesControllerProvider.notifier)
          .handle(codes.toList(), errorKey, detailType);
    }

    ref.listen(handleSelectedCodesControllerProvider, (p, n) {
      n.showAlertDialogOnError(context);
    });
    ref.observeLoading([handleSelectedCodesControllerProvider]);

    return Padding(
      padding: const EdgeInsets.all(Sizes.p8),
      child: Row(
        children: [
          Expanded(
            child: PrimaryButton(
              text: switch (detailType) {
                SynchronizerErrorDetailType.couponMarkedToReadAgain ||
                SynchronizerErrorDetailType.saleRequestWithError =>
                  'Reler todos'.hardcoded,
                SynchronizerErrorDetailType.schedule =>
                  'Excluir todos'.hardcoded,
                _ => 'BUG. Não implementado'.hardcoded,
              },
              onPressed: canProceed
                  ? () => onTap(selectableItems.map((e) => e.code).toSet())
                  : null,
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
                    SynchronizerErrorDetailType.couponMarkedToReadAgain ||
                    SynchronizerErrorDetailType.saleRequestWithError =>
                      'Reler selecionados'.hardcoded,
                    SynchronizerErrorDetailType.schedule =>
                      'Excluir selecionados'.hardcoded,
                    _ => 'BUG. Não implementado'.hardcoded,
                  },

                  onPressed: hasSelectedItems && canProceed
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
