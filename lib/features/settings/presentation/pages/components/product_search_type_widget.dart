import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../controllers/controllers.dart';

class ProductSearchTypeWidget extends ConsumerWidget {
  final AppSettingsEntity settings;
  const ProductSearchTypeWidget({super.key, required this.settings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            selectedValue: settings.searchPreference,
            onChanged: (searchPreference) async {
              await ref
                  .read(appSettingsStateControllerProvider.notifier)
                  .changeSettings(
                    settings.copyWith(searchPreference: searchPreference),
                  );
            },
          ),
        ],
      ),
    );
  }
}
