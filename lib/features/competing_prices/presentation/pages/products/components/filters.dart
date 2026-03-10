import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../core/presentation/controllers/products/products.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../controllers/controllers.dart';
import '../products.dart';

class Filters extends ConsumerWidget {
  final ProductsPage widget;
  const Filters({super.key, required this.widget});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedItem = ref.watch(selectedItemUIControllerProvider);

    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    final restrictProducts = ref.watch(
      researchsStateControllerProvider(widget.enterpriseCode).select(
        (s) =>
            s.value
                ?.firstWhereOrNull((e) => e.Code == widget.researchCode)
                ?.RestrictProducts ??
            false,
      ),
    );

    return ExpansionTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.p12),
      ),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.p12),
      ),
      backgroundColor: theme.primaryColorLight.withAlpha(30),
      collapsedBackgroundColor: theme.primaryColorDark.withAlpha(30),
      childrenPadding: const EdgeInsets.symmetric(horizontal: Sizes.p8),
      tilePadding: const EdgeInsets.symmetric(horizontal: Sizes.p8),
      iconColor: theme.primaryColorDark,
      collapsedIconColor: theme.primaryColor,
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      initiallyExpanded: false,
      title: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Filtrar produtos   '.hardcoded,
              style: theme.textTheme.titleMedium,
            ),
            if (!restrictProducts)
              TextSpan(
                text: selectedItem.onlyAssociateds
                    ? '(associados)'.hardcoded
                    : '(não associados)'.hardcoded,
                style: theme.textTheme.bodySmall?.copyWith(
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
                style: theme.textTheme.bodySmall?.copyWith(
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
                  return DefaultSwitch(
                    title: 'Somente associados'.hardcoded,
                    value: selectedItem.onlyAssociateds,
                    onChanged: (value) {
                      ref
                          .read(selectedItemUIControllerProvider.notifier)
                          .update(
                            selectedItem.copyWith(onlyAssociateds: value),
                          );
                    },
                  );
                },
              ),
            gapH4,
            if (selectedItem.onlyAssociateds)
              Consumer(
                builder: (_, ref, _) {
                  return DefaultSegmentedButtons<
                    SearchProductCompetingPriceType
                  >(
                    selectedValue: selectedItem.searchType,
                    onChanged: (value) {
                      ref
                          .read(selectedItemUIControllerProvider.notifier)
                          .update(selectedItem.copyWith(searchType: value));
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
                        widget.enterpriseCode,
                        BsRoutine.researchOfPrice,
                        Modules.competingPrices,
                      ),
                    ).select((s) => s.isLoading),
                  ),
                  text: selectedItem.onlyAssociateds
                      ? 'Consultar${selectedItem.searchType == SearchProductCompetingPriceType.all ? '' : ' todos'.hardcoded} ${selectedItem.searchType.name.toLowerCase()}'
                            .hardcoded
                      : 'Consultar todos não associados'.hardcoded,
                  icon: Icon(isIOS ? CupertinoIcons.search : Icons.search),
                  onPressed: () {
                    ref
                        .read(
                          searchProductsStateControllerProvider(
                            SearchProductKey(
                              widget.enterpriseCode,
                              BsRoutine.researchOfPrice,
                              Modules.competingPrices,
                            ),
                          ).notifier,
                        )
                        .loadProducts(
                          exactProductCode: null,
                          GetProductsJsonParams(
                            enterpriseCodes: [widget.enterpriseCode],
                            searchValue: '%',
                            competingPricesParams: CompetingPricesParams(
                              ResearchOfPriceCode: widget.researchCode,
                              ConcurrentCode: widget.concurrentCode,
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
