import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CouponItems extends StatelessWidget {
  const CouponItems({super.key, required this.items});
  final List<BSFCouponSynchronizerEntity> items;

  @override
  Widget build(BuildContext context) {
    final provider = selectedSynchronizerCodesStateControllerProvider(
      SynchronizerErrorDetailType.coupon,
    );

    return ResponsiveListFlow(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          clipBehavior: .hardEdge,
          child: InkWell(
            child: Padding(
              padding: const EdgeInsets.all(Sizes.p8),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  if (item is BSFCouponSynchronizerErrorDetailEntity)
                    Align(
                      alignment: Alignment.topRight,
                      child: Consumer(
                        builder: (_, ref, _) {
                          final isSelected = ref.watch(
                            provider.select((s) => s.contains(item.code)),
                          );
                          return BaseCheckBox(
                            name: 'Selecionar cupom'.hardcoded,
                            enabled: isSelected,
                            onChanged: (_) =>
                                ref.read(provider.notifier).select(item.code),
                            width: Sizes.p24,
                            height: Sizes.p24,
                          );
                        },
                      ),
                    ),
                  TitleAndSubTitle(
                    title: 'Empresa'.hardcoded,
                    subTitle: item.enterprisePersonalizedCode,
                  ),
                  TitleAndSubTitle(
                    title: 'Última leitura'.hardcoded,
                    subTitle: item.creationDate.formatDate(
                      DateFormatType.ddMMyyyyHHmm,
                    ),
                  ),
                  TitleAndSubTitle(
                    title: 'Dia da venda'.hardcoded,
                    subTitle: item.deliveryDate.formatDate(
                      DateFormatType.ddMMyyyyHHmm,
                    ),
                  ),
                  TitleAndSubTitle(
                    title: 'Cupom'.hardcoded,
                    subTitle: item.couponNumber,
                  ),
                  TitleAndSubTitle(
                    title: 'PDV'.hardcoded,
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
