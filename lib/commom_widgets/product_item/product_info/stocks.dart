import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Stocks extends ConsumerWidget {
  const Stocks({super.key, required this.widget});

  final ProductInfoModal widget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupedStocks = groupBy(
      widget.product.Stocks ?? <StockEntity>[],
      (stock) => (stock).Enterprise,
    );

    final enterpriseNames = groupedStocks.keys.toList();

    return CustomScrollView(
      physics: const ClampingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(bottom: Sizes.p8),
            child: BaseText.headline(
              context.l10n.stocks,
              textAlign: TextAlign.center,
            ),
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
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                title: Row(
                  children: [
                    Expanded(
                      child: BaseText(
                        enterpriseName,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        ref
                            .read(tryAccessModuleControllerProvider.notifier)
                            .tryAccess(
                              module: Modules.adjustStock,
                              context: context,
                              route: Routes.adjustStocks,
                              enterpriseCode:
                                  stocksForEnterprise.first.EnterpriseCode,
                              extra: widget.product,
                              pathParameters: {
                                'enterpriseCode': stocksForEnterprise
                                    .first
                                    .EnterpriseCode
                                    .toString(),
                              },
                            );
                      },
                      icon: const PlatformIcon(
                        cupertinoIcon: CupertinoIcons.pencil,
                        materialIcon: Icons.edit,
                      ),
                    ),
                  ],
                ),
                initiallyExpanded: true,
                children: stocksForEnterprise.map((stock) {
                  return Row(
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
