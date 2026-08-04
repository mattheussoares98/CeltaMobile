import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
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
                BaseText.title(' ${item.productName} '),
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
                title: 'Última carga do produto'.hardcoded,
                subTitle: item.lastChargeOfProduct!.formatDate(
                  DateFormatType.ddMMyyyyHHmm,
                ),
              ),
            if (item.lastChargeOfSalePrice != null)
              TitleAndSubTitle(
                title: 'Última carga de preços'.hardcoded,
                subTitle: item.lastChargeOfSalePrice!.formatDate(
                  DateFormatType.ddMMyyyyHHmm,
                ),
              ),
            if (item.lastChargeOfStock != null)
              TitleAndSubTitle(
                title: 'Última carga de estoques'.hardcoded,
                subTitle: item.lastChargeOfStock!.formatDate(
                  DateFormatType.ddMMyyyyHHmm,
                ),
              ),
            if (item.hasSendingRestriction)
              Row(
                children: [
                  const Icon(Icons.warning, color: Colors.orange, size: 16),
                  gapW4,
                  Expanded(
                    child: Text(
                      'Possui restrição de envio'.hardcoded,
                      style: context.theme.textTheme.bodySmall?.copyWith(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
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
