import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:celta_inventario/commom_widgets/default_choice_chip.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/settings/presentation/controllers/controllers.dart';

class ProductSearchTypeWidget extends StatelessWidget {
  const ProductSearchTypeWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
          Consumer(
            builder: (context, ref, _) {
              final searchPreference = ref.watch(
                appSettingsStateControllerProvider.select(
                  (s) => s.value?.searchPreference,
                ),
              );
              return DefaultChoiceChip(
                items: SearchProductTypePreference.values,
                selectedValue: searchPreference,
                onChanged: (searchPreference) async {
                  await ref
                      .read(appSettingsStateControllerProvider.notifier)
                      .changeSettings(searchPreference: searchPreference);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
