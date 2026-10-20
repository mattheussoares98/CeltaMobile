import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/buy_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/buy_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'searched_buy_request_summary.dart';

class SearchedBuyRequestItem extends StatelessWidget {
  final VoidCallback? onTapItem; //! is not passed on details page
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: .stretch,
                children: [
                  if (buyRequest.personalizedCode != null && onTapItem != null)
                    BaseRichText(
                      texts: [
                        BaseText(context.l10n.customCodePrefix),
                        BaseText.titleMedium(
                          buyRequest.personalizedCode!.substring(0, 8),
                          fontWeight: FontWeight.bold,
                        ),
                        BaseText.titleMedium(
                          buyRequest.personalizedCode!.substring(8, 12),
                          fontWeight: FontWeight.bold,
                          color: context.theme.colorScheme.secondary,
                        ),
                      ],
                    ),
                  if (buyRequest.dateOfCreation != null)
                    TitleAndSubTitle(
                      title: context.l10n.createdOn,
                      subTitle: buyRequest.dateOfCreation?.formatDate(
                        .ddMMyyyyHHmm,
                      ),
                    ),
                  if (buyRequest.deliveryDate != null)
                    TitleAndSubTitle(
                      title: context.l10n.deliveredOn,
                      subTitle: buyRequest.deliveryDate?.formatDate(
                        .ddMMyyyyHHmm,
                      ),
                    ),
                  if (buyRequest.buyer?.name?.isNotEmpty ?? false)
                    TitleAndSubTitle(
                      title: context.l10n.buyer,
                      subTitle: buyRequest.buyer?.name,
                    ),
                  if (buyRequest.supplier?.name?.isNotEmpty ?? false)
                    TitleAndSubTitle(
                      title: context.l10n.supplier,
                      subTitle: buyRequest.supplier?.name,
                    ),
                  if (buyRequest.requestType?.name?.isNotEmpty ?? false)
                    TitleAndSubTitle(
                      title: context.l10n.requestTemplate,
                      subTitle: buyRequest.requestType?.name,
                    ),
                  if (onTapItem == null)
                    //! details page
                    _SearchedBuyRequestSummary(processCode: buyRequest.code),

                  TitleAndSubTitle(
                    title: context.l10n.netAmount,
                    subTitle: buyRequest.totalLiquid ?? 0,
                    subTitleIsPrice: true,
                  ),
                  if (buyRequest.observations?.isNotEmpty ?? false)
                    TitleAndSubTitle(
                      title: context.l10n.notes,
                      subTitle: buyRequest.observations,
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
