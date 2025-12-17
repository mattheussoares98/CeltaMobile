import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import '../../../constants/constants.dart';
import '../../../core/domain/entities/entities.dart';
import '../../commom_widgets.dart';

class Stocks extends StatelessWidget {
  const Stocks({super.key, required this.widget});

  final ProductInfoModal widget;

  @override
  Widget build(BuildContext context) {
    final groupedStocks = groupBy(
      widget.product.Stocks ?? <StockEntity>[],
      (stock) => (stock).Enterprise,
    );
    final theme = Theme.of(context);

    final enterpriseNames = groupedStocks.keys.toList();

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(bottom: Sizes.p8),
            child: DefaultTitle(title: 'Estoques'.hardcoded),
          ),
        ),

        SliverList.builder(
          itemCount: enterpriseNames.length,
          itemBuilder: (_, index) {
            final enterpriseName = enterpriseNames[index];

            final stocksForEnterprise = groupedStocks[enterpriseName]!;

            return Padding(
              padding: const EdgeInsets.only(bottom: Sizes.p8),
              child: ExpansionTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Sizes.p12),
                ),
                collapsedShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Sizes.p12),
                ),
                backgroundColor: theme.primaryColorLight.withAlpha(120),
                collapsedBackgroundColor: theme.primaryColorLight.withAlpha(60),
                childrenPadding: const EdgeInsets.all(Sizes.p8),
                iconColor: theme.primaryColorDark,
                collapsedIconColor: theme.primaryColor,
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                title: Text(
                  enterpriseName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                initiallyExpanded: true,
                children: stocksForEnterprise.map((stock) {
                  return Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: TitleAndSubTitle(
                          title: stock.StockName,
                          subTitle: stock.StockQuantity,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            );
          },
        ),
      ],
    );
  }
}
