import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/constants.dart';
import '../../../core/domain/entities/entities.dart';
import '../../../routing/routing.dart';
import '../../commom_widgets.dart';

class Stocks extends ConsumerWidget {
  const Stocks({super.key, required this.widget});

  final ProductInfoModal widget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupedStocks = groupBy(
      widget.product.Stocks ?? <StockEntity>[],
      (stock) => (stock).Enterprise,
    );
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    final enterpriseNames = groupedStocks.keys.toList();

    return CustomScrollView(
      physics: const ClampingScrollPhysics(),
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
                backgroundColor: theme.primaryColorLight.withAlpha(30),
                collapsedBackgroundColor: theme.primaryColorDark.withAlpha(30),
                childrenPadding: const EdgeInsets.all(Sizes.p8),
                iconColor: theme.primaryColorDark,
                collapsedIconColor: theme.primaryColor,
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        enterpriseName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        ref
                            .read(
                              tryAccessModuleControllerProvider(
                                Modules.adjustStock,
                              ).notifier,
                            )
                            .tryAccess(
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
                      icon: Icon(isIOS ? CupertinoIcons.pencil : Icons.edit),
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
