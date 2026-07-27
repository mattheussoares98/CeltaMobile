import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
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
      return Center(
        child: BaseText.titleMedium('Nenhuma compra foi encontrada'.hardcoded),
      );
    }
    return CustomScrollView(
      physics: const ClampingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(bottom: Sizes.p8),
            child: BaseText.headline(
              'Últimas compras'.hardcoded,
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
                  title: 'Fornecedor'.hardcoded,
                  subTitle: buy.Supplier,
                ),
                TitleAndSubTitle(
                  title: 'Data'.hardcoded,
                  subTitle: DateTime.parse(
                    buy.EntranceDate,
                  ).formatDate(DateFormatType.ddMMyyyyHHmm),
                ),
                TitleAndSubTitle(
                  title: 'CFOP'.hardcoded,
                  subTitle: buy.FiscalCode,
                ),
                TitleAndSubTitle(
                  title: 'Número'.hardcoded,
                  subTitle: buy.Number,
                ),
                TitleAndSubTitle(
                  title: 'Embalagem'.hardcoded,
                  subTitle: buy.Packing,
                ),
                TitleAndSubTitle(
                  title: 'Quantidade'.hardcoded,
                  subTitle: buy.Quantity.toString().toBrazilianNumber(),
                ),
                if (buy.Code != null)
                  Consumer(
                    builder: (_, ref, _) {
                      return Align(
                        child: PrimaryTextButton(
                          text: 'Detalhes da compra'.hardcoded,
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
