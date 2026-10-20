import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/presentation/controllers/controllers.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CouponItems extends ConsumerWidget {
  const CouponItems({super.key, required this.items});
  final List<EcCouponSynchronizerEntity> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = selectedSynchronizerCodesStateControllerProvider(
      SynchronizerErrorDetailType.coupon,
    );

    return ResponsiveListFlow(
      itemCount: items.length,
      padding: const EdgeInsets.all(Sizes.p8),
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          clipBehavior: .hardEdge,
          child: InkWell(
            onTap: item is EcSelectableSynchronizerErrorDetailEntity
                ? () => ref.read(provider.notifier).select(item.code)
                : null,
            child: Padding(
              padding: const EdgeInsets.all(Sizes.p8),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TitleAndSubTitle(
                          title: context.l10n.enterprise,
                          subTitle: item.enterprisePersonalizedCode,
                        ),
                      ),
                      if (item is EcSelectableSynchronizerErrorDetailEntity)
                        Consumer(
                          builder: (_, ref, _) {
                            final isSelected = ref.watch(
                              provider.select((s) => s.contains(item.code)),
                            );
                            return BaseCheckBox(
                              name: context.l10n.selectReceipt,
                              enabled: isSelected,
                              onChanged: (_) =>
                                  ref.read(provider.notifier).select(item.code),
                              width: Sizes.p20,
                              height: Sizes.p20,
                            );
                          },
                        ),
                    ],
                  ),
                  TitleAndSubTitle(
                    title: context.l10n.lastRead,
                    subTitle: item.creationDate.formatDate(
                      DateFormatType.ddMMyyyyHHmm,
                    ),
                  ),
                  TitleAndSubTitle(
                    title: context.l10n.saleDate,
                    subTitle: item.deliveryDate.formatDate(
                      DateFormatType.ddMMyyyyHHmm,
                    ),
                  ),
                  TitleAndSubTitle(
                    title: context.l10n.receipt,
                    subTitle: item.couponNumber,
                  ),
                  TitleAndSubTitle(
                    title: context.l10n.pos,
                    subTitle: item.cashRegisterNumber,
                  ),
                  for (var i = 0; i < item.details.length; i++)
                    Column(
                      children: [
                        if (i > 0 && i < item.details.length) const Divider(),
                        BaseText.title(
                          item.details[i],
                          color: Colors.red,
                          textAlign: .start,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
