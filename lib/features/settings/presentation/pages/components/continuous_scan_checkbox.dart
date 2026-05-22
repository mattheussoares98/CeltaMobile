import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/features/settings/presentation/controllers/controllers.dart';

class ContinuousScanCheckbox extends ConsumerWidget {
  final Modules module;
  const ContinuousScanCheckbox({super.key, required this.module});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = ref.watch(
      appSettingsStateControllerProvider.select((s) {
        if (module == Modules.inventory) {
          return s.value?.inventoryUseContinuousScan;
        } else if (module == Modules.expeditionConference) {
          return s.value?.expeditionUseContinuousScan;
        } else if (module == Modules.receipt) {
          return s.value?.receiptUseContinuousScan;
        }
        throw Exception(
          'You should add the module here to update correctly the value'
              .hardcoded,
        );
      }),
    );

    void updateValue() {
      ref
          .read(appSettingsStateControllerProvider.notifier)
          .changeSettings(
            inventoryUseContinuousScan: module == Modules.inventory
                ? !(enabled ?? false)
                : null,
            expeditionUseContinuousScan: module == Modules.expeditionConference
                ? !(enabled ?? false)
                : null,
            receiptUseContinuousScan: module == Modules.receipt
                ? !(enabled ?? false)
                : null,
          );
    }

    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        onTap: updateValue,
        child: Padding(
          padding: const EdgeInsets.only(
            left: Sizes.p8,
            right: Sizes.p8,
            bottom: Sizes.p8,
          ),
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
                  Consumer(
                    builder: (_, ref, _) {
                      return Checkbox(
                        value: ref.watch(
                          appSettingsStateControllerProvider.select((s) {
                            if (module == Modules.inventory) {
                              return s.value?.inventoryUseContinuousScan ==
                                  true;
                            } else if (module == Modules.expeditionConference) {
                              return s.value?.expeditionUseContinuousScan ==
                                  true;
                            } else if (module == Modules.receipt) {
                              return s.value?.receiptUseContinuousScan == true;
                            }
                            throw Exception(
                              'You should add the module here to update correctly the value'
                                  .hardcoded,
                            );
                          }),
                        ),
                        onChanged: (value) => updateValue(),
                      );
                    },
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
