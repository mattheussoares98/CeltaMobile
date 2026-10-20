import 'package:celta_inventario/utils/utils.dart';
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
            context.l10n.salesOrdersReadErrors,
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
            final detailsQuantity = ref.watch(
              detailsProvider.select((s) {
                final items = s.value?.items;

                final productsItems = items
                    ?.whereType<
                      EcProductWithErrorSynchronizerErrorGroupEntity
                    >();

                if (productsItems?.isNotEmpty ?? false) {
                  return productsItems!
                      .map((e) => e.errors.length)
                      .reduce((a, b) => a + b);
                }

                return items?.length;
              }),
            );

            final countQuantity = ref.watch(
              synchronizerCountStateControllerProvider.select(
                (s) => s.value
                    ?.firstWhereOrNull((e) => e.errorKey == errorKey)
                    ?.count,
              ),
            );

            final errorQuantity = detailsQuantity ?? countQuantity;

            return BaseRichText(
              maxLines: 2,
              texts: [
                if (errorQuantity != null) BaseText.error('($errorQuantity) '),
                if ((detailsQuantity ?? 0) > 0 &&
                    (countQuantity ?? 0) > 0 &&
                    detailsQuantity != countQuantity)
                  BaseText.error('/ ($countQuantity) ', fontStyle: .italic),
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
            return SynchronizerEmptyErrors(detailsProvider: detailsProvider);
          }

          final selectableItems = data.items
              .whereType<EcSelectableSynchronizerErrorDetailEntity>()
              .toList();
          final items = switch (data.detailType) {
            SynchronizerErrorDetailType.coupon => CouponItems(
              items: data.items.cast<EcCouponSynchronizerErrorDetailEntity>(),
            ),
            SynchronizerErrorDetailType.couponMarkedToReadAgain => CouponItems(
              items: data.items
                  .cast<EcCouponMarkedToReadSynchronizerErrorDetailEntity>(),
            ),
            SynchronizerErrorDetailType.nFeDisable => NfeDisableItems(
              items: data.items
                  .cast<EcNFeDisableSynchronizerErrorDetailEntity>(),
            ),
            SynchronizerErrorDetailType.schedule => ScheduleItems(
              items: data.items.cast<EcScheduleSynchronizerErrorDetailEntity>(),
            ),
            SynchronizerErrorDetailType.saleRequestWithError =>
              SaleRequestWithErrorsItems(
                errorKey: errorKey,
                items: data.items
                    .cast<
                      EcSaleRequestWithErrorSynchronizerErrorDetailEntity
                    >(),
              ),
            SynchronizerErrorDetailType.productWithError =>
              SynchronizerProductsWithErrosPage(
                items: data.items
                    .cast<EcProductWithErrorSynchronizerErrorGroupEntity>(),
                errorKey: errorKey,
              ),
            SynchronizerErrorDetailType.saleRequestMarked =>
              SaleRequestMarkedItems(
                items: data.items
                    .cast<EcSaleRequestMarkedSynchronizerErrorDetailEntity>(),
              ),
            SynchronizerErrorDetailType.sendData => SynchronizerSendDataPage(
              items: data.items.cast<EcSendDataSynchronizerErrorDetailEntity>(),
              errorKey: errorKey,
            ),
            SynchronizerErrorDetailType.customerWithError =>
              CustomersWithErrorsItems(
                items: data.items
                    .cast<EcCustomerWithErrorSynchronizerErrorDetailEntity>(),
              ),
            SynchronizerErrorDetailType.readBleeding => ReadBleedingsItems(
              items: data.items
                  .cast<EcReadBleedingSynchronizerErrorDetailEntity>(),
              errorKey: errorKey,
            ),
            SynchronizerErrorDetailType.cashierMovement => CashierMovementItems(
              items: data.items
                  .cast<EcCashierMovementSynchronizerErrorDetailEntity>(),
              errorKey: errorKey,
            ),
            SynchronizerErrorDetailType.fiscalNote ||
            SynchronizerErrorDetailType.transaction ||
            SynchronizerErrorDetailType.treasuryMovement ||
            SynchronizerErrorDetailType.mapSummarySaleEcf ||
            SynchronizerErrorDetailType.customerWaitingApproval ||
            SynchronizerErrorDetailType.saleRequestWaitingApproval ||
            SynchronizerErrorDetailType.correspondentBanking ||
            SynchronizerErrorDetailType.saleMovementScanntechLoad =>
              NotImplementedDetailType(
                detailType: data.detailType,
                errorKey: errorKey,
              ),
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
