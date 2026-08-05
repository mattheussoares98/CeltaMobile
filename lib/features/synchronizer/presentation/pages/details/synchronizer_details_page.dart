import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/synchronizer/presentation/pages/components/components.dart';
import 'package:celta_inventario/features/synchronizer/presentation/pages/details/components/components.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
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
      floatingActionButton:
          (errorKey.toLowerCase().contains(
            'pedidos de vendas com erros durante a leitura',
            //! this errorKey should always be visible and should have this floating to add new sale requests
          ))
          ? FloatingActionButton(
              onPressed: () {
                showModalPage(
                  InsertSaleRequestToReadAgainModal(errorKey: errorKey),
                  context,
                );
              },
              child: const PlatformIcon(
                cupertinoIcon: CupertinoIcons.add,
                materialIcon: Icons.add,
              ),
            )
          : null,
      appBar: BaseAppBar(
        titleWidget: Consumer(
          builder: (_, ref, _) {
            final errorQuantity =
                ref.watch(
                  detailsProvider.select((s) {
                    final items = s.value?.items;

                    final productsItems = items
                        ?.whereType<
                          BSFProductWithErrorSynchronizerErrorGroupEntity
                        >();

                    if (productsItems?.isNotEmpty ?? false) {
                      return productsItems!
                          .map((e) => e.errors.length)
                          .reduce((a, b) => a + b);
                    }

                    return items?.length;
                  }),
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
                errorKey: errorKey,
                items: data.items
                    .cast<
                      BSFSaleRequestWithErrorSynchronizerErrorDetailEntity
                    >(),
              ),
            SynchronizerErrorDetailType.productWithError =>
              SynchronizerProductsWithErrosPage(
                items: data.items
                    .cast<BSFProductWithErrorSynchronizerErrorGroupEntity>(),
                errorKey: errorKey,
              ),
            SynchronizerErrorDetailType.saleRequestMarked =>
              SaleRequestMarkedItems(
                items: data.items
                    .cast<BSFSaleRequestMarkedSynchronizerErrorDetailEntity>(),
              ),
            SynchronizerErrorDetailType.cashierMovement ||
            SynchronizerErrorDetailType.fiscalNote ||
            SynchronizerErrorDetailType.transaction ||
            SynchronizerErrorDetailType.treasuryMovement ||
            SynchronizerErrorDetailType.mapSummarySaleEcf ||
            SynchronizerErrorDetailType.customerWithError ||
            SynchronizerErrorDetailType.customerWaitingApproval ||
            SynchronizerErrorDetailType.saleRequestWaitingApproval ||
            SynchronizerErrorDetailType.readBleeding ||
            SynchronizerErrorDetailType.correspondentBanking ||
            SynchronizerErrorDetailType.saleMovementScanntechLoad ||
            SynchronizerErrorDetailType.sendData =>
              const NotImplementedDetailType(),
          };

          return Column(
            children: [
              if (selectableItems.isNotEmpty)
                SelectableActions(
                  detailType: data.detailType,
                  errorKey: errorKey,
                  selectableItems: selectableItems,
                ),
              Expanded(child: items),
            ],
          );
        },
      ),
    );
  }
}
