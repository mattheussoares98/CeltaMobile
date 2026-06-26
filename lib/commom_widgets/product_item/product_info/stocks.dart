import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:celta_inventario/utils/utils.dart';
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
            child: DefaultText.headline(
              'Estoques'.hardcoded,
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Sizes.p12),
                ),
                collapsedShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Sizes.p12),
                ),
                backgroundColor: context.theme.primaryColorLight.withAlpha(30),
                collapsedBackgroundColor: context.theme.primaryColorDark
                    .withAlpha(30),
                childrenPadding: const EdgeInsets.all(Sizes.p8),
                iconColor: context.theme.primaryColorDark,
                collapsedIconColor: context.theme.primaryColor,
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                title: Row(
                  children: [
                    Expanded(
                      child: DefaultText(
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
                              replace: false,
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
