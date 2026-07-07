import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';

class Addresses extends StatelessWidget {
  const Addresses({super.key, required this.widget});

  final ProductInfoModal widget;

  @override
  Widget build(BuildContext context) {
    if (widget.product.StorageAreaAddress == null &&
        (widget.product.StockByEnterpriseAssociateds?.length ?? 0) == 0) {
      return Center(
        child: BaseText.titleMedium(
          'Não há endereços cadastrados para esse produto'.hardcoded,
        ),
      );
    }

    return CustomScrollView(
      physics: const ClampingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(bottom: Sizes.p8),
            child: BaseText.headline(
              'Endereços'.hardcoded,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Center(
            child: TitleAndSubTitle(
              title: 'Endereço na empresa selecionada',
              subTitle:
                  widget.product.StorageAreaAddress == null ||
                      widget.product.StorageAreaAddress!.isEmpty
                  ? 'Não há'
                  : widget.product.StorageAreaAddress,
              subTitleStyle: context.theme.textTheme.titleSmall,
            ),
          ),
        ),
        SliverList.builder(
          itemCount: widget.product.StockByEnterpriseAssociateds?.length ?? 0,
          itemBuilder: (_, index) {
            final stock = widget.product.StockByEnterpriseAssociateds![index];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                TitleAndSubTitle(
                  title: 'Empresa'.hardcoded,
                  subTitle: stock.Enterprise,
                ),
                TitleAndSubTitle(
                  title: 'Endereço(s)'.hardcoded,
                  subTitle: stock.StorageAreaAddress ?? 'Não há'.hardcoded,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
