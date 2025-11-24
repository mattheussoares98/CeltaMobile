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

class SearchTypeSegmentedButtons extends ConsumerWidget {
  final int enterpriseCode;
  final int researchCode;
  final int concurrentCode;
  final bool restrictProducts;
  const SearchTypeSegmentedButtons({
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Filtrar produtos'.hardcoded, style: theme.textTheme.titleMedium),
        gapH4,
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
            text:
                'Consultar${selectedItem.searchType == SearchProductCompetingPriceType.all ? '' : ' todos'.hardcoded} ${selectedItem.searchType.name.toLowerCase()}'
                    .hardcoded,
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
    );
  }
}
