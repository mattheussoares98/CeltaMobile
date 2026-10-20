import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/buy_movement/domain/entities/entities.dart';
import 'package:celta_inventario/features/buy_movement/presentation/controllers/controllers.dart';
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
      tag: 'buy_request_${buyMovement.code}',
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
                  TitleAndSubTitle(
                    title: context.l10n.document,
                    subTitle: buyMovement.documentNumber,
                  ),
                  if (buyMovement.userOfEntrance?.name?.isNotEmpty ?? false)
                    TitleAndSubTitle(
                      title: context.l10n.entranceUser,
                      subTitle: buyMovement.userOfEntrance?.name,
                    ),
                  if (buyMovement.dateOfCreation != null)
                    TitleAndSubTitle(
                      title: context.l10n.createdOn,
                      subTitle: buyMovement.dateOfCreation?.formatDate(
                        .ddMMyyyyHHmm,
                      ),
                    ),
                  if (buyMovement.dateOfEmission != null)
                    TitleAndSubTitle(
                      title: context.l10n.issuedOn,
                      subTitle: buyMovement.dateOfEmission?.formatDate(
                        .ddMMyyyyHHmm,
                      ),
                    ),
                  if (buyMovement.dateOfEntrance != null)
                    TitleAndSubTitle(
                      title: context.l10n.receivedOn,
                      subTitle: buyMovement.dateOfEntrance?.formatDate(
                        .ddMMyyyyHHmm,
                      ),
                    ),
                  if (buyMovement.buyers?.isNotEmpty ?? false)
                    TitleAndSubTitle(
                      title: context.l10n.buyers,
                      subTitle: buyMovement.buyers
                          ?.map((e) => e.name)
                          .join('; '),
                    ),
                  if (buyMovement.supplier?.name?.isNotEmpty ?? false)
                    TitleAndSubTitle(
                      title: context.l10n.supplier,
                      subTitle: buyMovement.supplier?.name,
                    ),
                  if (buyMovement.requests?.isNotEmpty ?? false)
                    TitleAndSubTitle(
                      title: context.l10n.orders,
                      subTitle: buyMovement.requests?.join('; '),
                    ),
                  if (onTapItem == null)
                    //! details page
                    _SearchedBuyMovementSummary(processCode: buyMovement.code),

                  TitleAndSubTitle(
                    title: context.l10n.netAmount,
                    subTitle: buyMovement.totalLiquid ?? 0,
                    subTitleIsPrice: true,
                  ),
                  if (buyMovement.observations?.isNotEmpty ?? false)
                    TitleAndSubTitle(
                      title: context.l10n.notes,
                      subTitle: buyMovement.observations,
                    ),
                  if (buyMovement.isCancelled == true &&
                      (buyMovement.userOfCancellation?.name?.isNotEmpty ??
                          false))
                    BaseText.error(
                      context.l10n.purchaseCancelledBy(
                        buyMovement.userOfCancellation?.name ?? '',
                      ),
                    ),
                  if (onTapItem != null && PlatformUtil.isIOS)
                    Align(
                      alignment: .centerRight,
                      child: PrimaryTextButton(
                        text: context.l10n.details,
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
