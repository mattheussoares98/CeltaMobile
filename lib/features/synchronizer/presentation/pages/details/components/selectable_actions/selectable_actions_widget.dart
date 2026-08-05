// lib/features/synchronizer/presentation/pages/details/components/selectable_actions/selectable_actions_widget.dart
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/resource/resource.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'selectable_action.dart';

class SelectableActions extends ConsumerWidget {
  const SelectableActions({
    super.key,
    required this.detailType,
    required this.errorKey,
    required this.selectableItems,
    this.actions = const [],
  });

  final SynchronizerErrorDetailType detailType;
  final String errorKey;
  final List<SelectableSynchronizerErrorDetailEntity> selectableItems;
  final List<SelectableAction> actions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCodes = ref.watch(
      selectedSynchronizerCodesStateControllerProvider(detailType),
    );
    final hasSelected = selectedCodes.isNotEmpty;

    final canDelete = ref.watch(
      canAccessResourceStateControllerProvider(
        BsRoutine.generic,
        BsResource.synchronizerDelete,
      ).select((s) => s.value == true),
    );

    void markToReadAgain(Set<int> codes) {
      ref
          .read(handleSelectedCodesControllerProvider.notifier)
          .markToReadAgain(codes.toList(), errorKey, detailType);
    }

    void deleteSelected(Set<int> codes) {
      if (!canDelete) {
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
          .deleteSelected(codes.toList(), errorKey, detailType);
    }

    final isSaleRequestMarkedToReadAgain =
        detailType == SynchronizerErrorDetailType.saleRequestWithError &&
        errorKey.toLowerCase().contains(
          'pedidos de vendas com erros durante a leitura',
        );

    final List<SelectableAction> handledActions = [];

    if (actions.isEmpty && !isSaleRequestMarkedToReadAgain) {
      switch (detailType) {
        case SynchronizerErrorDetailType.coupon:
          handledActions.addAll([
            SelectableAction(
              label: 'Reler todos'.hardcoded,
              onPressed: () => markToReadAgain(
                selectableItems.expand((e) => e.selectableCodes).toSet(),
              ),
            ),
            SelectableAction(
              label: 'Reler selecionados'.hardcoded,
              onPressed: hasSelected
                  ? () => markToReadAgain(selectedCodes)
                  : null,
            ),
          ]);
        case SynchronizerErrorDetailType.schedule:
          handledActions.addAll([
            SelectableAction(
              label: 'Excluir todos'.hardcoded,
              onPressed: () => deleteSelected(
                selectableItems.expand((e) => e.selectableCodes).toSet(),
              ),
            ),
            SelectableAction(
              label: 'Excluir selecionados'.hardcoded,
              onPressed: hasSelected
                  ? () => deleteSelected(selectedCodes)
                  : null,
            ),
          ]);
        case SynchronizerErrorDetailType.saleRequestWithError:
          handledActions.addAll([
            SelectableAction(
              label: 'Reler todos'.hardcoded,
              onPressed: () => markToReadAgain(
                selectableItems.expand((e) => e.selectableCodes).toSet(),
              ),
            ),
            SelectableAction(
              label: 'Reler selecionados'.hardcoded,
              onPressed: hasSelected
                  ? () => markToReadAgain(selectedCodes)
                  : null,
            ),
            SelectableAction(
              label: 'Excluir selecionados'.hardcoded,
              onPressed: hasSelected && canDelete
                  ? () => deleteSelected(selectedCodes)
                  : null,
            ),
          ]);
        default:
          break;
      }
    }
    if (actions.isEmpty && handledActions.isEmpty) {
      return const SizedBox.shrink();
    }

    ref.listen(handleSelectedCodesControllerProvider, (p, n) {
      n.showAlertDialogOnError(context);
    });
    ref.observeLoading([handleSelectedCodesControllerProvider]);

    return Padding(
      padding: const EdgeInsets.all(Sizes.p8),
      child: SizedBox(
        width: Breakpoint.tablet,
        child: Row(
          children: (actions.isEmpty ? handledActions : actions).mapIndexed((
            index,
            action,
          ) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: index == 0 ? 0.0 : Sizes.p8),
                child: PrimaryButton(
                  text: action.label,
                  onPressed: action.onPressed,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
