import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../localization/string_hardcoded.dart';
import '../../controllers/controllers.dart';

class ContinuousScanCheckbox extends ConsumerWidget {
  final AppSettingsEntity appSettings;
  final Modules module;
  const ContinuousScanCheckbox({
    super.key,
    required this.appSettings,
    required this.module,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void updateValue() {
      ref
          .read(appSettingsStateControllerProvider.notifier)
          .changeSettings(
            appSettings.copyWith(
              inventoryUseContinuousScan: module == Modules.inventory
                  ? !appSettings.inventoryUseContinuousScan
                  : null,
            ),
          );
    }

    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: updateValue,
        child: Padding(
          padding: const EdgeInsets.only(left: Sizes.p8, bottom: Sizes.p8),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Auto scan'.hardcoded,
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  Checkbox(
                    value: ref.watch(
                      appSettingsStateControllerProvider.select(
                        (s) => s.value?.inventoryUseContinuousScan,
                      ),
                    ),
                    onChanged: (value) => updateValue(),
                  ),
                ],
              ),
              Text(
                'Ao ativar essa opção, a câmera será aberta automaticamente para escanear o próximo produto após confirmar uma quantidade',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
