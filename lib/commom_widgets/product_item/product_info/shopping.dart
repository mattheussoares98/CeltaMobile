import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Shopping extends StatelessWidget {
  const Shopping({super.key, required this.widget});

  final ProductInfoModal widget;

  @override
  Widget build(BuildContext context) {
    if (widget.product.LastBuyEntrances == null ||
        widget.product.LastBuyEntrances!.isEmpty) {
      return Center(child: BaseText.titleMedium(context.l10n.noPurchasesFound));
    }
    return CustomScrollView(
      physics: const ClampingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(bottom: Sizes.p8),
            child: BaseText.headline(
              context.l10n.latestPurchases,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        SliverList.builder(
          itemCount: widget.product.LastBuyEntrances?.length ?? 0,
          itemBuilder: (_, index) {
            final buy = widget.product.LastBuyEntrances![index];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                TitleAndSubTitle(
                  title: context.l10n.supplier,
                  subTitle: buy.Supplier,
                ),
                TitleAndSubTitle(
                  title: context.l10n.date,
                  subTitle: DateTime.parse(
                    buy.EntranceDate,
                  ).formatDate(DateFormatType.ddMMyyyyHHmm),
                ),
                TitleAndSubTitle(
                  title: context.l10n.cfop,
                  subTitle: buy.FiscalCode,
                ),
                TitleAndSubTitle(
                  title: context.l10n.number,
                  subTitle: buy.Number,
                ),
                TitleAndSubTitle(
                  title: context.l10n.packaging,
                  subTitle: buy.Packing,
                ),
                TitleAndSubTitle(
                  title: context.l10n.quantity,
                  subTitle: buy.Quantity.toString().toBrazilianNumber(),
                ),
                if (buy.Code != null)
                  Consumer(
                    builder: (_, ref, _) {
                      return Align(
                        child: PrimaryTextButton(
                          text: context.l10n.purchaseDetails,
                          platformIcon: const PlatformIcon(
                            cupertinoIcon: CupertinoIcons.arrow_up_right,
                            materialIcon: Icons.arrow_outward,
                          ),
                          onPressed: () {
                            ref
                                .read(
                                  tryAccessModuleControllerProvider.notifier,
                                )
                                .tryAccess(
                                  context: context,
                                  route: Routes.buyMovementDetails,
                                  enterpriseCode: widget.product.EnterpriseCode,
                                  module: Modules.buyMovement,
                                  pathParameters: {
                                    'buyMovementCode': buy.Code.toString(),
                                    'enterpriseCode': widget
                                        .product
                                        .EnterpriseCode
                                        .toString(),
                                  },
                                );
                          },
                        ),
                      );
                    },
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
