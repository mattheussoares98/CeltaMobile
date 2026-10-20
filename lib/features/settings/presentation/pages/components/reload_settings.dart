import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/providers/app_settings/app_settings.dart';

class ReloadSettings extends ConsumerWidget {
  const ReloadSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Text(context.l10n.settingsLoadFailed),
        gapH32,
        PrimaryButton(
          text: context.l10n.tryAgain,
          onPressed: () => ref.invalidate(appSettingsRepositoryProvider),
        ),
      ],
    );
  }
}
