// lib/features/synchronizer/presentation/pages/details/components/selectable_actions/selectable_actions_widget.dart
import 'dart:math';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/resource/resource.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/presentation/controllers/controllers.dart';
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
  final List<EcSelectableSynchronizerErrorDetailEntity> selectableItems;

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

    final notifier = ref.read(handleSelectedCodesControllerProvider.notifier);

    void markToReadAgain(Set<int> codes) {
      notifier.markToReadAgain(codes.toList(), errorKey, detailType);
    }

    void deleteSelected(Set<int> codes) {
      if (!canDelete) {
        showAlertDialog(
          context: context,
          title: context.l10n.attention2,
          content:
              context.l10n.yourUserDoesNotHavePermissionToPerformThisAction,
        );
        return;
      }
      notifier.deleteSelected(codes.toList(), errorKey, detailType);
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
              label: context.l10n.rereadAll,
              onPressed: () => markToReadAgain(
                selectableItems.expand((e) => e.selectableCodes).toSet(),
              ),
            ),
            SelectableAction(
              label: context.l10n.rereadSelected,
              onPressed: hasSelected
                  ? () => markToReadAgain(selectedCodes)
                  : null,
            ),
          ]);
        case SynchronizerErrorDetailType.schedule:
          actions.addAll([
            SelectableAction(
              label: context.l10n.deleteAll,
              onPressed: () => deleteSelected(
                selectableItems.expand((e) => e.selectableCodes).toSet(),
              ),
            ),
            SelectableAction(
              label: context.l10n.deleteSelected,
              onPressed: hasSelected
                  ? () => deleteSelected(selectedCodes)
                  : null,
            ),
          ]);
        case SynchronizerErrorDetailType.saleRequestWithError:
          actions.addAll([
            SelectableAction(
              label: context.l10n.rereadAll,
              onPressed: () => markToReadAgain(
                selectableItems.expand((e) => e.selectableCodes).toSet(),
              ),
            ),
            SelectableAction(
              label: context.l10n.rereadSelected,
              onPressed: hasSelected
                  ? () => markToReadAgain(selectedCodes)
                  : null,
            ),
            SelectableAction(
              label: context.l10n.deleteSelected,
              onPressed: hasSelected && canDelete
                  ? () => deleteSelected(selectedCodes)
                  : null,
            ),
          ]);
        case SynchronizerErrorDetailType.productWithError:
          final currentIndex = ref.watch(
            selectedSynchronizerProductPageIndexStateControllerProvider,
          );
          final activeType = EcProductWithErrorType.values[currentIndex];
          final items = selectableItems
              .cast<EcProductWithErrorSynchronizerErrorGroupEntity>()
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

          final allCodesParams = getParams(allCodes);
          final selectedCodesParams = getParams(selectedCodes.toList());

          if (group != null && group.errors.isNotEmpty) {
            final ignoreButtons = [
              SelectableAction(
                label: context.l10n.ignoreAll,
                onPressed: () => notifier.markProductsToIgnoreError(
                  allCodesParams,
                  errorKey,
                ),
                color: Colors.red,
              ),
              SelectableAction(
                label: context.l10n.ignoreSelected,
                onPressed: hasSelected
                    ? () => notifier.markProductsToIgnoreError(
                        selectedCodesParams,
                        errorKey,
                      )
                    : null,
                color: Colors.red,
              ),
            ];
            final sendProductsButtons = [
              SelectableAction(
                label: context.l10n.resendAll,
                onPressed: () =>
                    notifier.markProductsToSendAgain(allCodesParams, errorKey),
              ),
              SelectableAction(
                label: context.l10n.resendSelected,
                onPressed: hasSelected
                    ? () => notifier.markProductsToSendAgain(
                        selectedCodesParams,
                        errorKey,
                      )
                    : null,
              ),
            ];
            switch (activeType) {
              case EcProductWithErrorType.error:
                actions.addAll([...sendProductsButtons, ...ignoreButtons]);
              case EcProductWithErrorType.markedToSendAgain:
                actions.addAll([
                  SelectableAction(
                    label: context.l10n.unmarkAll,
                    onPressed: () => notifier.unmarkProductsToSendAgain(
                      allCodesParams,
                      errorKey,
                    ),
                  ),
                  SelectableAction(
                    label: context.l10n.unmarkSelected,
                    onPressed: hasSelected
                        ? () => notifier.unmarkProductsToSendAgain(
                            selectedCodesParams,
                            errorKey,
                          )
                        : null,
                  ),
                  ...ignoreButtons,
                ]);
              case EcProductWithErrorType.markedToIgnoreError:
                actions.addAll(sendProductsButtons);
            }
          }
        case SynchronizerErrorDetailType.saleRequestMarked:
          void unmarkSaleRequests(Set<int> codes) {
            notifier.unmarkSaleRequestsMarked(codes.toList(), errorKey);
          }
          actions.addAll([
            SelectableAction(
              label: context.l10n.unmarkAll,
              onPressed: () => unmarkSaleRequests(
                selectableItems.expand((e) => e.selectableCodes).toSet(),
              ),
            ),
            SelectableAction(
              label: context.l10n.unmarkSelected,
              onPressed: hasSelected
                  ? () => unmarkSaleRequests(selectedCodes)
                  : null,
            ),
          ]);
        case SynchronizerErrorDetailType.sendData:
          final type = EcSendDataType.fromErrorKey(errorKey);
          final areMarked = errorKey.toLowerCase().contains('marcados');

          actions.addAll([
            SelectableAction(
              label: areMarked
                  ? context.l10n.unmarkSendingAll
                  : context.l10n.resendAll,
              onPressed: () => notifier.markSendDataToSendAgain(
                sendDataType: type,
                codes: selectableItems
                    .expand((e) => e.selectableCodes)
                    .toSet()
                    .toList(),
                errorKey: errorKey,
                mark: !areMarked,
              ),
            ),
            SelectableAction(
              label: areMarked
                  ? context.l10n.unmarkSendingSelected
                  : context.l10n.resendSelected,
              onPressed: hasSelected
                  ? () => notifier.markSendDataToSendAgain(
                      sendDataType: type,
                      codes: selectedCodes.toList(),
                      errorKey: errorKey,
                      mark: !areMarked,
                    )
                  : null,
            ),
          ]);
        case SynchronizerErrorDetailType.readBleeding:
          if (errorKey.toLowerCase().contains('marcadas') == false) {
            actions.addAll([
              SelectableAction(
                label: context.l10n.rereadAll2,
                onPressed: () => markToReadAgain(
                  selectableItems.expand((e) => e.selectableCodes).toSet(),
                ),
              ),
              SelectableAction(
                label: context.l10n.rereadSelected2,
                onPressed: hasSelected
                    ? () => markToReadAgain(selectedCodes)
                    : null,
              ),
            ]);
          }
        case SynchronizerErrorDetailType.cashierMovement:
          if (errorKey.toLowerCase().contains('marcados') == false) {
            actions.addAll([
              SelectableAction(
                label: context.l10n.rereadAll,
                onPressed: () => markToReadAgain(
                  selectableItems.expand((e) => e.selectableCodes).toSet(),
                ),
              ),
              SelectableAction(
                label: context.l10n.rereadSelected,
                onPressed: hasSelected
                    ? () => markToReadAgain(selectedCodes)
                    : null,
              ),
            ]);
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
