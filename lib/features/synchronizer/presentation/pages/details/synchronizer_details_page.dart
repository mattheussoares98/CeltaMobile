import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/synchronizer/presentation/pages/components/components.dart';
import 'package:celta_inventario/features/synchronizer/presentation/pages/details/components/components.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SynchronizerDetailsPage extends ConsumerWidget {
  const SynchronizerDetailsPage({super.key, required this.errorKey});
  final String errorKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailsProvider = synchronizerDetailsStateControllerProvider(
      errorKey,
    );

    return BaseScaffold(
      isScrollable: false,
      refreshProvider: detailsProvider,
      usePadding: false,
      appBar: BaseAppBar(
        titleWidget: Consumer(
          builder: (_, ref, _) {
            final errorQuantity =
                ref.watch(
                  detailsProvider.select((s) => s.value?.items.length),
                ) ??
                ref.watch(
                  synchronizerCountStateControllerProvider.select(
                    (s) => s.value
                        ?.firstWhereOrNull((e) => e.errorKey == errorKey)
                        ?.count,
                  ),
                );

            return BaseRichText(
              maxLines: 2,
              texts: [
                if (errorQuantity != null) BaseText.error('($errorQuantity) '),
                BaseText.title(errorKey, maxLines: 2),
              ],
            );
          },
        ),
      ),
      body: AsyncValueWidget(
        value: ref.watch(detailsProvider),
        tryAgain: () => ref.invalidate(detailsProvider),
        data: (data) {
          if (data.items.isEmpty) {
            return const SynchronizerEmptyErrors();
          }

          final selectableItems = data.items
              .whereType<SelectableSynchronizerErrorDetailEntity>()
              .toList();
          final items = switch (data.detailType) {
            SynchronizerErrorDetailType.coupon => CouponItems(
              items: data.items.cast<BSFCouponSynchronizerErrorDetailEntity>(),
            ),
            SynchronizerErrorDetailType.couponMarkedToReadAgain => CouponItems(
              items: data.items
                  .cast<BSFCouponMarkedToReadSynchronizerErrorDetailEntity>(),
            ),
            SynchronizerErrorDetailType.nFeDisable => NfeDisableItems(
              items: data.items
                  .cast<BSFNFeDisableSynchronizerErrorDetailEntity>(),
            ),
            SynchronizerErrorDetailType.schedule => ScheduleItems(
              items: data.items
                  .cast<BSFScheduleSynchronizerErrorDetailEntity>(),
            ),
            SynchronizerErrorDetailType.saleRequestWithError =>
              SaleRequestWithErrorsItems(
                items: data.items
                    .cast<
                      BSFSaleRequestWithErrorSynchronizerErrorDetailEntity
                    >(),
              ),
            SynchronizerErrorDetailType.cashierMovement ||
            SynchronizerErrorDetailType.fiscalNote ||
            SynchronizerErrorDetailType.transaction ||
            SynchronizerErrorDetailType.treasuryMovement ||
            SynchronizerErrorDetailType.mapSummarySaleEcf ||
            SynchronizerErrorDetailType.customerWithError ||
            SynchronizerErrorDetailType.customerWaitingApproval ||
            SynchronizerErrorDetailType.saleRequestWaitingApproval ||
            SynchronizerErrorDetailType.saleRequestMarked ||
            SynchronizerErrorDetailType.productWithError ||
            SynchronizerErrorDetailType.readBleeding ||
            SynchronizerErrorDetailType.correspondentBanking ||
            SynchronizerErrorDetailType.saleMovementScanntechLoad ||
            SynchronizerErrorDetailType.sendData =>
              const NotImplementedDetailType(),
          };

          //! When there is no readable (can mark to read again) return the items directly
          if (selectableItems.isEmpty) return items;

          return Column(
            children: [
              SelectableActions(
                detailType: data.detailType,
                selectableItems: selectableItems,
                errorKey: errorKey,
              ),
              Expanded(child: items),
            ],
          );
        },
      ),
    );
  }
}
