import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/buy_movement/domain/entities/entities.dart';
import 'package:celta_inventario/features/buy_movement/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'searched_buy_movement_summary.dart';

class SearchedBuyMovementItem extends StatelessWidget {
  final VoidCallback? onTapItem; //! is not passed on details page
  final EcBuyMovementDtoEntity buyMovement;
  const SearchedBuyMovementItem({
    super.key,
    this.onTapItem,
    required this.buyMovement,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'buy_request_${buyMovement.documentNumber}',
      child: Card(
        clipBehavior: .hardEdge,
        color: buyMovement.isCancelled == true ? Colors.red[50] : null,
        child: InkWell(
          onTap: PlatformUtil.isIOS ? null : onTapItem,
          child: Padding(
            padding: const EdgeInsets.all(Sizes.p8),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: .stretch,
                children: [
                  BaseRichText(
                    texts: [
                      BaseText('Documento '.hardcoded),
                      BaseText.titleMedium(
                        buyMovement.documentNumber.toString(),
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                  if (buyMovement.dateOfCreation != null)
                    TitleAndSubTitle(
                      title: 'Criado em'.hardcoded,
                      subTitle: buyMovement.dateOfCreation?.formatDate(
                        .ddMMyyyyHHmm,
                      ),
                    ),
                  if (buyMovement.dateOfEmission != null)
                    TitleAndSubTitle(
                      title: 'Emitido em'.hardcoded,
                      subTitle: buyMovement.dateOfEmission?.formatDate(
                        .ddMMyyyyHHmm,
                      ),
                    ),
                  if (buyMovement.dateOfEntrance != null)
                    TitleAndSubTitle(
                      title: 'Entrada em'.hardcoded,
                      subTitle: buyMovement.dateOfEntrance?.formatDate(
                        .ddMMyyyyHHmm,
                      ),
                    ),
                  if (buyMovement.buyers?.isNotEmpty ?? false)
                    TitleAndSubTitle(
                      title: 'Compradores'.hardcoded,
                      subTitle: buyMovement.buyers
                          ?.map((e) => e.name)
                          .join('; '),
                    ),
                  if (buyMovement.supplier?.name?.isNotEmpty ?? false)
                    TitleAndSubTitle(
                      title: 'Fornecedor'.hardcoded,
                      subTitle: buyMovement.supplier?.name,
                    ),
                  if (onTapItem == null)
                    //! details page
                    _SearchedBuyMovementSummary(processCode: buyMovement.code),

                  TitleAndSubTitle(
                    title: 'Valor líquido'.hardcoded,
                    subTitle: buyMovement.totalLiquid ?? 0,
                    subTitleIsPrice: true,
                  ),
                  if (buyMovement.observations?.isNotEmpty ?? false)
                    TitleAndSubTitle(
                      title: 'Observações'.hardcoded,
                      subTitle: buyMovement.observations,
                    ),
                  if (buyMovement.isCancelled == true &&
                      (buyMovement.userOfCancellation?.name?.isNotEmpty ??
                          false))
                    BaseRichText(
                      texts: [
                        BaseText.error(
                          buyMovement.userOfCancellation?.name ?? '',
                        ),
                        BaseText.error(' cancelou essa compra'.hardcoded),
                      ],
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
      ),
    );
  }
}
