import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/products/products.dart';
import 'package:celta_inventario/features/competing_prices/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Filters extends ConsumerWidget {
  final int enterpriseCode;
  final int researchCode;
  final int concurrentCode;
  const Filters({
    super.key,
    required this.enterpriseCode,
    required this.researchCode,
    required this.concurrentCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedItem = ref.watch(selectedItemUIControllerProvider);

    final restrictProducts = ref.watch(
      researchsStateControllerProvider(enterpriseCode).select(
        (s) =>
            s.value
                ?.firstWhereOrNull((e) => e.Code == researchCode)
                ?.RestrictProducts ??
            false,
      ),
    );

    return ExpansionTile(
      title: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Filtrar produtos   '.hardcoded,
              style: context.theme.textTheme.titleMedium,
            ),
            if (!restrictProducts)
              TextSpan(
                text: selectedItem.onlyAssociateds
                    ? '(associados)'.hardcoded
                    : '(não associados)'.hardcoded,
                style: context.theme.textTheme.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: selectedItem.onlyAssociateds
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            if (selectedItem.onlyAssociateds &&
                selectedItem.searchType != SearchProductCompetingPriceType.all)
              TextSpan(
                text: ' (${selectedItem.searchType.name})'.toLowerCase(),
                style: context.theme.textTheme.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
      ),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!restrictProducts)
              Consumer(
                builder: (_, ref, _) {
                  return BaseSwitch(
                    title: 'Somente associados'.hardcoded,
                    value: selectedItem.onlyAssociateds,
                    onChanged: (value) {
                      ref
                          .read(selectedItemUIControllerProvider.notifier)
                          .updateOnlyAssociateds(value);
                    },
                  );
                },
              ),
            gapH4,
            if (selectedItem.onlyAssociateds)
              Consumer(
                builder: (_, ref, _) {
                  return BaseSegmentedButtons<SearchProductCompetingPriceType>(
                    selectedValue: selectedItem.searchType,
                    itemLabelBuilder: (item) => item.name,
                    onChanged: (value) {
                      ref
                          .read(selectedItemUIControllerProvider.notifier)
                          .updateSearchType(value);
                    },
                    items: SearchProductCompetingPriceType.values,
                  );
                },
              ),
            gapH8,
            Consumer(
              builder: (_, ref, _) {
                return PrimaryButton(
                  isLoading: ref.watch(
                    searchProductsStateControllerProvider(
                      SearchProductKey(
                        enterpriseCode,
                        BsRoutine.researchOfPrice,
                        Modules.competingPrices,
                      ),
                    ).select((s) => s.isLoading),
                  ),
                  text: selectedItem.onlyAssociateds
                      ? 'Consultar${selectedItem.searchType == SearchProductCompetingPriceType.all ? '' : ' todos'.hardcoded} ${selectedItem.searchType.name.toLowerCase()}'
                            .hardcoded
                      : 'Consultar todos não associados'.hardcoded,
                  icon: const PlatformIcon(
                    cupertinoIcon: CupertinoIcons.search,
                    materialIcon: Icons.search,
                  ),
                  onPressed: () {
                    ref
                        .read(
                          searchProductsStateControllerProvider(
                            SearchProductKey(
                              enterpriseCode,
                              BsRoutine.researchOfPrice,
                              Modules.competingPrices,
                            ),
                          ).notifier,
                        )
                        .loadProducts(
                          exactProductCode: null,
                          GetProductsJsonParams(
                            enterpriseCodes: [enterpriseCode],
                            searchValue: '%',
                            competingPricesParams: CompetingPricesParams(
                              ResearchOfPriceCode: researchCode,
                              ConcurrentCode: concurrentCode,
                              OnlyAssociated: restrictProducts,
                              searchType: selectedItem.searchType,
                            ),
                          ),
                        );
                  },
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
