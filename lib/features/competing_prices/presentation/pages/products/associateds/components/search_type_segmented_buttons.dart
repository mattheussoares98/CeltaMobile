import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../../../core/domain/entities/entities.dart';
import '../../../../../../../localization/string_hardcoded.dart';
import '../../../../controllers/controllers.dart';

class SearchTypeSegmentedButtons extends ConsumerWidget {
  const SearchTypeSegmentedButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedItem = ref.watch(selectedItemUIControllerProvider);

    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Produtos a serem retornados'.hardcoded,
          style: theme.textTheme.bodySmall?.copyWith(
            fontStyle: FontStyle.italic,
          ),
        ),
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
      ],
    );
  }
}
