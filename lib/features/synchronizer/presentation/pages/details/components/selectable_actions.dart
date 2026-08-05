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
    final canDelete = ref.watch(
      canAccessResourceStateControllerProvider(
        BsRoutine.generic,
        BsResource.synchronizerDelete,
      ).select((s) => s.value == true),
    );

    bool validateCanDelete() {
      if (!canDelete) {
        showAlertDialog(
          context: context,
          title: 'Atenção'.hardcoded,
          content:
              'Seu usuário não possui permissão para realizar esse procedimento'
                  .hardcoded,
        );
        return false;
      }

      return true;
    }

    void markToReadAgain(Set<int> codes) {
      ref
          .read(handleSelectedCodesControllerProvider.notifier)
          .markToReadAgain(codes.toList(), errorKey, detailType);
    }

    void deleteSelected(Set<int> codes) {
      if (!validateCanDelete()) return;

      ref
          .read(handleSelectedCodesControllerProvider.notifier)
          .deleteSelected(codes.toList(), errorKey, detailType);
    }

    ref.listen(handleSelectedCodesControllerProvider, (p, n) {
      n.showAlertDialogOnError(context);
    });
    ref.observeLoading([handleSelectedCodesControllerProvider]);

    final hasSelectedItems = ref.watch(
      selectedSynchronizerCodesStateControllerProvider(
        detailType,
      ).select((s) => s.isNotEmpty),
    );

    final isSaleRequestMarkedToReadAgain =
        detailType == SynchronizerErrorDetailType.saleRequestWithError &&
        (errorKey.toLowerCase().contains(
          'pedidos de vendas com erros durante a leitura',
          //! this errorKey should always be visible and should have this floating to add new sale requests
        ));

    return Padding(
      padding: const EdgeInsets.all(Sizes.p8),
      child: SizedBox(
        width: Breakpoint.tablet,
        child: Row(
          children: [
            if (!isSaleRequestMarkedToReadAgain)
              Expanded(
                child: PrimaryButton(
                  text: switch (detailType) {
                    SynchronizerErrorDetailType.coupon ||
                    SynchronizerErrorDetailType.saleRequestWithError =>
                      'Reler todos'.hardcoded,
                    SynchronizerErrorDetailType.schedule =>
                      'Excluir todos'.hardcoded,
                    _ => 'BUG. Não implementado'.hardcoded,
                  },
                  onPressed: canDelete
                      ? () => detailType == SynchronizerErrorDetailType.schedule
                            ? deleteSelected(
                                selectableItems.map((e) => e.code).toSet(),
                              )
                            : markToReadAgain(
                                selectableItems.map((e) => e.code).toSet(),
                              )
                      : null,
                ),
              ),
            if (!isSaleRequestMarkedToReadAgain) ...[
              gapW8,
              Expanded(
                child: PrimaryButton(
                  text: switch (detailType) {
                    SynchronizerErrorDetailType.coupon ||
                    SynchronizerErrorDetailType.saleRequestWithError =>
                      'Reler selecionados'.hardcoded,
                    SynchronizerErrorDetailType.schedule =>
                      'Excluir selecionados'.hardcoded,
                    _ => 'BUG. Não implementado'.hardcoded,
                  },

                  onPressed: hasSelectedItems
                      ? () {
                          detailType == SynchronizerErrorDetailType.schedule
                              ? deleteSelected(
                                  ref.read(
                                    selectedSynchronizerCodesStateControllerProvider(
                                      detailType,
                                    ),
                                  ),
                                )
                              : markToReadAgain(
                                  ref.read(
                                    selectedSynchronizerCodesStateControllerProvider(
                                      detailType,
                                    ),
                                  ),
                                );
                        }
                      : null,
                ),
              ),
            ],
            if (detailType ==
                SynchronizerErrorDetailType.saleRequestWithError) ...[
              gapW8,
              Expanded(
                child: PrimaryButton(
                  text: 'Excluir selecionados'.hardcoded,
                  onPressed: hasSelectedItems && canDelete
                      ? () {
                          deleteSelected(
                            ref.read(
                              selectedSynchronizerCodesStateControllerProvider(
                                detailType,
                              ),
                            ),
                          );
                        }
                      : null,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
