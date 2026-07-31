import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';

class CouponItems extends StatelessWidget {
  const CouponItems({super.key, required this.items});
  final List<BSFCouponSynchronizerErrorDetailEntity> items;

  @override
  Widget build(BuildContext context) {
    return ResponsiveListFlow(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(Sizes.p8),
            child: Column(
              crossAxisAlignment: .start,
              children: [
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
        );
      },
    );
  }
}
