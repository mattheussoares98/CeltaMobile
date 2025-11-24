import 'package:flutter/material.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../../../core/domain/entities/entities.dart';
import '../../../../../../../localization/string_hardcoded.dart';

class SearchTypeSegmentedButtons extends StatelessWidget {
  final SearchProductCompetingPriceType searchType;
  final void Function(SearchProductCompetingPriceType) onChange;
  const SearchTypeSegmentedButtons({
    super.key,
    required this.searchType,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
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
          selectedValue: searchType,
          onChanged: onChange,
          items: SearchProductCompetingPriceType.values,
        ),
      ],
    );
  }
}
