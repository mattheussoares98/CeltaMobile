import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SynchronizerProductErrorItem extends StatelessWidget {
  const SynchronizerProductErrorItem({super.key, required this.item});
  final BSFProductWithErrorSynchronizerErrorDetailEntity item;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BaseRichText(
              texts: [
                BaseText.title(
                  '(${item.priceLookUp})',
                  color: context.theme.primaryColor,
                ),
                BaseText.titleMedium(' ${item.productName} '),
                BaseText.title(
                  item.formattedPacking,
                  color: context.theme.colorScheme.secondary,
                ),
              ],
            ),
            TitleAndSubTitle(
              title: 'Site'.hardcoded,
              subTitle: item.commerceSite,
            ),
            if (item.productCommerceSiteId.isNotEmpty)
              TitleAndSubTitle(
                title: 'ID do Produto no Site'.hardcoded,
                subTitle: item.productCommerceSiteId,
                copyableSubtitle: true,
              ),
            if (item.errorDescription.isNotEmpty &&
                item.errorDescription != item.errorMessage)
              TitleAndSubTitle(
                title: 'Descrição do erro'.hardcoded,
                subTitle: item.errorDescription,
              ),
            if (item.errorMessage.isNotEmpty)
              BaseText.error(item.errorMessage, textAlign: .start),
            if (item.lastChargeOfProduct != null)
              TitleAndSubTitle(
                title: 'Carga do produto'.hardcoded,
                subTitle: item.lastChargeOfProduct!.formatDate(
                  DateFormatType.ddMMyyyyHHmm,
                ),
              ),
            if (item.lastChargeOfSalePrice != null)
              TitleAndSubTitle(
                title: 'Carga de preços'.hardcoded,
                subTitle: item.lastChargeOfSalePrice!.formatDate(
                  DateFormatType.ddMMyyyyHHmm,
                ),
              ),
            if (item.lastChargeOfStock != null)
              TitleAndSubTitle(
                title: 'Carga de estoques'.hardcoded,
                subTitle: item.lastChargeOfStock!.formatDate(
                  DateFormatType.ddMMyyyyHHmm,
                ),
              ),
            Row(
              children: [
                PlatformIcon(
                  cupertinoIcon: item.hasSendingRestriction
                      ? CupertinoIcons.exclamationmark_triangle
                      : CupertinoIcons.check_mark,
                  materialIcon: item.hasSendingRestriction
                      ? Icons.warning
                      : Icons.check,
                  color: item.hasSendingRestriction
                      ? Colors.orange
                      : Colors.green,
                  size: 16,
                ),
                gapW4,
                Expanded(
                  child: BaseText(
                    item.hasSendingRestriction
                        ? 'Não enviado ao site'.hardcoded
                        : 'Enviado ao site'.hardcoded,
                    color: item.hasSendingRestriction
                        ? Colors.orange
                        : Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
