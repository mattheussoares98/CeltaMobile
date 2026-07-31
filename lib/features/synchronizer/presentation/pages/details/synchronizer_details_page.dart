import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/synchronizer/presentation/pages/details/components/components.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SynchronizerDetailsPage extends ConsumerWidget {
  const SynchronizerDetailsPage({super.key, required this.errorKey});
  final String errorKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = synchronizerDetailsStateControllerProvider(errorKey);
    final errorQuantity = ref.watch(
      synchronizerCountStateControllerProvider.select(
        (s) => s.value?.firstWhereOrNull((e) => e.errorKey == errorKey)?.count,
      ),
    );

    return BaseScaffold(
      isScrollable: false,
      refreshProvider: provider,
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
        value: ref.watch(provider),
        tryAgain: () => ref.invalidate(provider),
        data: (data) {
          final detailType = data.detailType;
          return switch (detailType) {
            SynchronizerErrorDetailType.coupon => CouponItems(
              items: data.items as List<BSFCouponSynchronizerErrorDetailEntity>,
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
        },
      ),
    );
  }
}
