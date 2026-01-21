import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import '../../../constants/constants.dart';
import '../../commom_widgets.dart';

class Addresses extends StatelessWidget {
  const Addresses({super.key, required this.widget});

  final ProductInfoModal widget;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.product.StorageAreaAddress == null &&
        (widget.product.StockByEnterpriseAssociateds?.length ?? 0) == 0) {
      return Center(
        child: Text(
          'Não há endereços cadastrados para esse produto'.hardcoded,
          style: theme.textTheme.titleMedium,
        ),
      );
    }

    return CustomScrollView(
      physics: const ClampingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(bottom: Sizes.p8),
            child: DefaultTitle(title: 'Endereços'.hardcoded),
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
              subTitleStyle: theme.textTheme.titleSmall,
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
