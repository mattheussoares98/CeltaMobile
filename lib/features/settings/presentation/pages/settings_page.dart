import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../core/domain/entities/entities.dart';
import '../../../../core/providers/providers.dart';
import '../controllers/controllers.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(appSettingsStateControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Configurações'.hardcoded)),
      body: AsyncValueWidget(
        value: value,
        tryAgain: () {
          ref.invalidate(appSettingsRepositoryProvider); //TODO test the error
        },
        data: (settings) {
          return Column(
            children: [
              DefaultSegmentedButtons(
                items: SearchProductTypePreference.values,
                selectedValue: settings?.searchPreference,
                onChanged: (searchPreference) {
                  debugPrint(searchPreference.name);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
