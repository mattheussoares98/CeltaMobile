import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/constants.dart';
import '../commom_widgets.dart';

class Addresses extends ConsumerWidget {
  const Addresses({super.key, required this.widget});

  final ProductInfoModal widget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return CustomScrollView(
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
              subTitle: widget.product.StorageAreaAddress ?? 'Não há',
              subTitleStyle: theme.textTheme.titleSmall,
            ),
          ),
        ),

        SliverList.builder(
          itemCount: widget.product.StockByEnterpriseAssociateds?.length,
          itemBuilder: (_, index) {
            final stock = widget.product.StockByEnterpriseAssociateds![index];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(),
                TitleAndSubTitle(
                  title: 'Empresa'.hardcoded,
                  subTitle: stock.Enterprise,
                ),
                TitleAndSubTitle(
                  title: 'Endereço'.hardcoded,
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
