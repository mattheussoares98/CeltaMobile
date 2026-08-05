// lib/features/synchronizer/presentation/pages/details/components/selectable_actions/selectable_actions_widget.dart
import 'dart:math';

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
  });

  final SynchronizerErrorDetailType detailType;
  final String errorKey;
  final List<SelectableSynchronizerErrorDetailEntity> selectableItems;

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

    final List<SelectableAction> actions = [];

    if (!isSaleRequestMarkedToReadAgain) {
      switch (detailType) {
        case SynchronizerErrorDetailType.coupon:
          actions.addAll([
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
          actions.addAll([
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
          actions.addAll([
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
        case SynchronizerErrorDetailType.productWithError:
          final currentIndex = ref.watch(
            selectedSynchronizerProductPageIndexStateControllerProvider,
          );
          final selectedCodes = ref.watch(
            selectedSynchronizerCodesStateControllerProvider(
              SynchronizerErrorDetailType.productWithError,
            ),
          );
          final activeType = BSFProductWithErrorType.values[currentIndex];
          final items = selectableItems
              .cast<BSFProductWithErrorSynchronizerErrorGroupEntity>()
              .where((e) => e.type == activeType);

          final group = items.firstWhereOrNull((e) => e.type == activeType);
          final allCodes =
              group?.errors.map((e) => e.code).toList() ?? const [];
          final hasSelected = selectedCodes.any((e) => allCodes.contains(e));

          List<ProductWithErrorActionParams> getParams(List<int> targetCodes) {
            if (group == null) return [];
            return group.errors
                .where((e) => targetCodes.contains(e.code))
                .map(
                  (e) => ProductWithErrorActionParams(
                    enterpriseCode: e.enterpriseCode,
                    productCode: e.code,
                    productPackingCode: e.productPackingCode,
                    enterpriseCommerceSiteCode: e.enterpriseCommerceSiteCode,
                  ),
                )
                .toList();
          }

          final notifier = ref.read(
            handleSelectedCodesControllerProvider.notifier,
          );
          final allCodesParams = getParams(allCodes);
          final selectedCodesParams = getParams(selectedCodes.toList());

          if (group != null && group.errors.isNotEmpty) {
            final ignoreButtons = [
              SelectableAction(
                label: 'Ignorar todos'.hardcoded,
                onPressed: () => notifier.markProductsToIgnoreError(
                  allCodesParams,
                  errorKey,
                ),
                color: Colors.red,
              ),
              SelectableAction(
                label: 'Ignorar selecionados'.hardcoded,
                onPressed: hasSelected
                    ? () => notifier.markProductsToIgnoreError(
                        selectedCodesParams,
                        errorKey,
                      )
                    : null,
                color: Colors.red,
              ),
            ];
            switch (activeType) {
              case BSFProductWithErrorType.error:
                actions.addAll([
                  SelectableAction(
                    label: 'Reenviar todos'.hardcoded,
                    onPressed: () => notifier.markProductsToSendAgain(
                      allCodesParams,
                      errorKey,
                    ),
                  ),
                  SelectableAction(
                    label: 'Reenviar selecionados'.hardcoded,
                    onPressed: hasSelected
                        ? () => notifier.markProductsToSendAgain(
                            selectedCodesParams,
                            errorKey,
                          )
                        : null,
                  ),
                  ...ignoreButtons,
                ]);
              case BSFProductWithErrorType.markedToSendAgain:
                actions.addAll([
                  SelectableAction(
                    label: 'Desmarcar todos'.hardcoded,
                    onPressed: () => notifier.unmarkProductsToSendAgain(
                      allCodesParams,
                      errorKey,
                    ),
                  ),
                  SelectableAction(
                    label: 'Desmarcar selecionados'.hardcoded,
                    onPressed: hasSelected
                        ? () => notifier.unmarkProductsToSendAgain(
                            selectedCodesParams,
                            errorKey,
                          )
                        : null,
                  ),
                  ...ignoreButtons,
                ]);
              case BSFProductWithErrorType.markedToIgnoreError:
                break;
            }
          }
        default:
          break;
      }
    }
    if (actions.isEmpty) {
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
          key: ValueKey(Random().nextInt(100000)),
          //* when using this on ProductsWithError page, because it is being used
          //* on more than one page, should use this key to avoid the impression
          //* that is using the same button when changing the page index
          children: actions.mapIndexed((index, action) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: index == 0 ? 0.0 : Sizes.p8),
                child: PrimaryButton(
                  text: action.label,
                  onPressed: action.onPressed,
                  backgroundColor: action.color,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
