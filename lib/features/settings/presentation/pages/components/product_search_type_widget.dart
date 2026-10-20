import 'package:celta_inventario/commom_widgets/base_choice_chip.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/settings/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/localization.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductSearchTypeWidget extends StatelessWidget {
  const ProductSearchTypeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Sizes.p4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Tipo de pesquisa de produtos'.hardcoded,
            textAlign: TextAlign.center,
            style: context.theme.textTheme.titleMedium,
          ),
          gapH8,
          Consumer(
            builder: (context, ref, _) {
              final searchPreference = ref.watch(
                appSettingsStateControllerProvider.select(
                  (s) => s.value?.searchPreference,
                ),
              );
              return BaseChoiceChip<SearchProductTypePreference>(
                items: SearchProductTypePreference.values,
                selections: [?searchPreference],
                itemLabelBuilder: (item) =>
                    context.l10n.searchPreferenceName(item),
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
