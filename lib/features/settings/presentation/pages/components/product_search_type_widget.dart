import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../controllers/controllers.dart';

class ProductSearchTypeWidget extends ConsumerWidget {
  final AsyncValue<AppSettingsEntity?> asyncValue;
  const ProductSearchTypeWidget({super.key, required this.asyncValue});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          'Tipo de pesquisa de produtos'.hardcoded,
          style: theme.textTheme.titleMedium,
        ),
        gapH8,
        DefaultSegmentedButtons(
          items: SearchProductTypePreference.values,
          selectedValue: asyncValue.value?.searchPreference,
          onChanged: (searchPreference) async {
            await ref
                .read(appSettingsStateControllerProvider.notifier)
                .changeSettings(
                  asyncValue.value!.copyWith(
                    searchPreference: searchPreference,
                  ),
                );
          },
        ),
      ],
    );
  }
}
