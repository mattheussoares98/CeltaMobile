import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/buy_request/domain/entities/entities.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchedBuyRequestItem extends StatelessWidget {
  final VoidCallback? onTapItem;
  final EcBuyRequestDtoEntity buyRequest;
  const SearchedBuyRequestItem({
    super.key,
    this.onTapItem,
    required this.buyRequest,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'buy_request_${buyRequest.code}',
      child: Card(
        clipBehavior: .hardEdge,
        child: InkWell(
          onTap: PlatformUtil.isIOS ? null : onTapItem,
          child: Padding(
            padding: const EdgeInsets.all(Sizes.p8),
            child: Column(
              crossAxisAlignment: .stretch,
              children: [
                if (buyRequest.personalizedCode != null)
                  BaseRichText(
                    texts: [
                      BaseText('Cód personalizado: '.hardcoded),
                      BaseText.titleMedium(
                        buyRequest.personalizedCode!.substring(0, 8).hardcoded,
                        fontWeight: FontWeight.bold,
                      ),
                      BaseText.titleMedium(
                        buyRequest.personalizedCode!.substring(8, 12).hardcoded,
                        fontWeight: FontWeight.bold,
                        color: context.theme.colorScheme.secondary,
                      ),
                    ],
                  ),
                TitleAndSubTitle(
                  title: 'Criado em'.hardcoded,
                  subTitle: buyRequest.dateOfCreation?.formatDate(
                    .ddMMyyyyHHmm,
                  ),
                ),
                if (buyRequest.deliveryDate != null)
                  TitleAndSubTitle(
                    title: 'Entregue em'.hardcoded,
                    subTitle: buyRequest.deliveryDate?.formatDate(
                      .ddMMyyyyHHmm,
                    ),
                  ),
                if (buyRequest.buyer != null)
                  TitleAndSubTitle(
                    title: 'Comprador'.hardcoded,
                    subTitle: buyRequest.buyer?.name,
                  ),
                if (buyRequest.supplier != null)
                  TitleAndSubTitle(
                    title: 'Fornecedor'.hardcoded,
                    subTitle: buyRequest.supplier?.name,
                  ),
                if (buyRequest.requestType != null)
                  TitleAndSubTitle(
                    title: 'Modelo pedido'.hardcoded,
                    subTitle: buyRequest.requestType?.name,
                  ),
                if (buyRequest.observations?.isNotEmpty ?? false)
                  TitleAndSubTitle(
                    title: 'Observações'.hardcoded,
                    subTitle: buyRequest.observations,
                  ),
                TitleAndSubTitle(
                  title: 'Valor total'.hardcoded,
                  subTitle: buyRequest.totalLiquid,
                  subTitleIsPrice: true,
                ),
                if (onTapItem != null && PlatformUtil.isIOS)
                  Align(
                    alignment: .centerRight,
                    child: PrimaryTextButton(
                      text: 'Detalhes'.hardcoded,
                      onPressed: onTapItem,
                      platformIcon: const PlatformIcon(
                        cupertinoIcon: CupertinoIcons.pencil,
                        materialIcon: Icons.edit,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
