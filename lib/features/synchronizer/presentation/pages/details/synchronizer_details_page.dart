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
    final errorQuantity =
        ref.watch(detailsProvider.select((s) => s.value?.items.length)) ??
        ref.watch(
          synchronizerCountStateControllerProvider.select(
            (s) =>
                s.value?.firstWhereOrNull((e) => e.errorKey == errorKey)?.count,
          ),
        );

    void markToReadAgain(
      SynchronizerErrorDetailType detailType,
      List<int> codes,
    ) {
      ref
          .read(
            markSynchronizerItemsToReadAgainControllerProvider(
              detailType,
            ).notifier,
          )
          .markToReadAgain(codes, errorKey);
    }

    return BaseScaffold(
      isScrollable: false,
      refreshProvider: detailsProvider,
      appBar: BaseAppBar(
        titleWidget: BaseRichText(
          maxLines: 2,
          texts: [
            if (errorQuantity != null) BaseText.error('($errorQuantity) '),
            BaseText.title(errorKey, maxLines: 2),
          ],
        ),
      ),
      body: AsyncValueWidget(
        value: ref.watch(detailsProvider),
        tryAgain: () => ref.invalidate(detailsProvider),
        data: (data) {
          if (data.items.isEmpty) {
            return const SynchronizerEmptyErrors();
          }

          final rereadableItems = data.items
              .whereType<RereadableSynchronizerErrorDetailEntity>()
              .toList();
          final items = switch (data.detailType) {
            SynchronizerErrorDetailType.coupon => CouponItems(
              items: data.items.cast<BSFCouponSynchronizerErrorDetailEntity>(),
            ),
            SynchronizerErrorDetailType.couponMarkedToReadAgain => CouponItems(
              items: data.items
                  .cast<BSFCouponMarkedToReadSynchronizerErrorDetailEntity>(),
            ),
            SynchronizerErrorDetailType.cashierMovement => Container(),
            SynchronizerErrorDetailType.fiscalNote => Container(),
            SynchronizerErrorDetailType.nFeDisable => Container(),
            SynchronizerErrorDetailType.schedule => Container(),
            SynchronizerErrorDetailType.transaction => Container(),
            SynchronizerErrorDetailType.treasuryMovement => Container(),
            SynchronizerErrorDetailType.mapSummarySaleEcf => Container(),
            SynchronizerErrorDetailType.customerWithError => Container(),
            SynchronizerErrorDetailType.customerWaitingApproval => Container(),
            SynchronizerErrorDetailType.saleRequestWithError => Container(),
            SynchronizerErrorDetailType.saleRequestWaitingApproval =>
              Container(),
            SynchronizerErrorDetailType.saleRequestMarked => Container(),
            SynchronizerErrorDetailType.productWithError => Container(),
            SynchronizerErrorDetailType.readBleeding => Container(),
            SynchronizerErrorDetailType.correspondentBanking => Container(),
            SynchronizerErrorDetailType.saleMovementScanntechLoad =>
              Container(),
            SynchronizerErrorDetailType.sendData => Container(),
          };

          //! When there is no readable (can mark to read again) return the items directly
          if (rereadableItems.isEmpty) return items;

          return Column(
            children: [
              RereadActions(
                detailType: data.detailType,
                onMarkAll: () {
                  markToReadAgain(
                    data.detailType,
                    rereadableItems.map((e) => e.code).toList(),
                  );
                },
                onMarkSelected: () {
                  markToReadAgain(
                    data.detailType,
                    ref.read(
                      selectedSynchronizerCodesStateControllerProvider(
                        data.detailType,
                      ),
                    ),
                  );
                },
              ),
              Expanded(child: items),
            ],
          );
        },
      ),
    );
  }
}
