import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../../../core/data/datasource/products/products.dart';
import '../../../../../../../core/domain/entities/entities.dart';
import '../../../../../../../core/presentation/controllers/products/products.dart';
import '../../../../../../../localization/string_hardcoded.dart';
import '../../../../controllers/controllers.dart';

class Filters extends ConsumerWidget {
  final int enterpriseCode;
  final int researchCode;
  final int concurrentCode;
  final bool restrictProducts;
  const Filters({
    super.key,
    required this.enterpriseCode,
    required this.researchCode,
    required this.concurrentCode,
    required this.restrictProducts,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedItem = ref.watch(selectedItemUIControllerProvider);

    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return ExpansionTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.p12),
      ),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.p12),
      ),
      backgroundColor: theme.primaryColorLight.withAlpha(20),
      collapsedBackgroundColor: theme.primaryColorLight.withAlpha(60),
      childrenPadding: const EdgeInsets.all(Sizes.p8),
      iconColor: theme.primaryColorDark,
      collapsedIconColor: theme.primaryColor,
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      title: Text(
        'Filtrar produtos'.hardcoded,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      initiallyExpanded: true,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!restrictProducts)
              DefaultSwitch(
                title: 'Somente associados'.hardcoded,
                value: selectedItem.onlyAssociateds,
                onChanged: (value) {
                  ref
                      .read(selectedItemUIControllerProvider.notifier)
                      .update(selectedItem.copyWith(onlyAssociateds: value));
                },
              ),
            gapH4,
            if (selectedItem.onlyAssociateds)
              DefaultSegmentedButtons<SearchProductCompetingPriceType>(
                selectedValue: selectedItem.searchType,
                onChanged: (value) {
                  ref
                      .read(selectedItemUIControllerProvider.notifier)
                      .update(selectedItem.copyWith(searchType: value));
                },
                items: SearchProductCompetingPriceType.values,
              ),
            gapH8,
            SizedBox(
              child: PrimaryButton(
                text: selectedItem.onlyAssociateds
                    ? 'Consultar${selectedItem.searchType == SearchProductCompetingPriceType.all ? '' : ' todos'.hardcoded} ${selectedItem.searchType.name.toLowerCase()}'
                          .hardcoded
                    : 'Consultar todos não associados'.hardcoded,
                icon: Icon(isIOS ? CupertinoIcons.search : Icons.search),
                onPressed: () {
                  ref
                      .read(
                        searchProductsStateControllerProvider(
                          enterpriseCode,
                          BsRoutine.researchOfPrice,
                          Modules.competingPrices,
                        ).notifier,
                      )
                      .loadProducts(
                        searchValue: '%',
                        enterpriseCodes: [enterpriseCode],
                        competingPricesFilters: CompetingPricesFilters(
                          ResearchOfPriceCode: researchCode,
                          ConcurrentCode: concurrentCode,
                          OnlyAssociated: restrictProducts,
                          searchType: selectedItem.searchType,
                        ),
                      );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
