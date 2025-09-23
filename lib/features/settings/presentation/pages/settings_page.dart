import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../controllers/controllers.dart';
import 'components/components.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(appSettingsStateControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Configurações'.hardcoded)),
        leadingWidth: 0,
        leading: SizedBox.shrink(),
      ),
      body: ResponsiveScrollableWidget(
        child: Column(
          children: [
            if (asyncValue.hasError)
              ReloadSettings()
            else ...[
              ProductSearchTypeWidget(asyncValue: asyncValue),
            ],
          ],
        ),
      ),
    );
  }
}
