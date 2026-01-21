import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../controllers/controllers.dart';

class ProductSearchTypeWidget extends ConsumerWidget {
  const ProductSearchTypeWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchPreference = ref.watch(
      appSettingsStateControllerProvider.select(
        (s) => s.value?.searchPreference,
      ),
    );
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(Sizes.p4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Tipo de pesquisa de produtos'.hardcoded,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium,
          ),
          gapH8,
          DefaultSegmentedButtons(
            items: SearchProductTypePreference.values,
            selectedValue: searchPreference,
            onChanged: (searchPreference) async {
              await ref
                  .read(appSettingsStateControllerProvider.notifier)
                  .changeSettings(searchPreference: searchPreference);
            },
          ),
        ],
      ),
    );
  }
}
