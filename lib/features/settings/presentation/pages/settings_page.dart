import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../core/domain/entities/entities.dart';
import '../controllers/controllers.dart';
import 'components/components.dart';

class SettingsPage extends ConsumerWidget {
  final Modules? module;
  const SettingsPage({super.key, required this.module});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;
    final isAndroid = theme.platform == TargetPlatform.android;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Center(child: Text('Configurações'.hardcoded)),
        leadingWidth: 0,
        leading: const SizedBox.shrink(),
      ),
      body:
          ref.watch(
            appSettingsStateControllerProvider.select((s) => s.hasError),
          )
          ? Center(
              child: PrimaryTextButton(
                text: 'Recarregar configurações'.hardcoded,
                onPressed: () =>
                    ref.invalidate(appSettingsStateControllerProvider),
              ),
            )
          : Column(
              children: [
                const ProductSearchTypeWidget(),
                if ([
                      Modules.inventory,
                      Modules.expeditionConference,
                    ].any((x) => x == module) &&
                    (isIOS || isAndroid)) ...[
                  ContinuousScanCheckbox(module: module!),
                ],
              ],
            ),
    );
  }
}
