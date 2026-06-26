import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/settings/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/settings/presentation/pages/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsPage extends StatelessWidget {
  final Modules? module;
  const SettingsPage({super.key, required this.module});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      isScrollable: true,
      body: Column(
        children: [
          DefaultText.headline('Configurações'.hardcoded),
          gapH16,
          Consumer(
            builder: (_, ref, _) {
              final hasError = ref.watch(
                appSettingsStateControllerProvider.select((s) => s.hasError),
              );
              if (hasError) {
                return Center(
                  child: PrimaryTextButton(
                    text: 'Recarregar configurações'.hardcoded,
                    onPressed: () =>
                        ref.invalidate(appSettingsStateControllerProvider),
                  ),
                );
              }

              return Column(
                children: [
                  const ProductSearchTypeWidget(),
                  if ([
                        Modules.inventory,
                        Modules.expeditionConference,
                        Modules.receipt,
                      ].any((x) => x == module) &&
                      (PlatformUtil.isMobile)) ...[
                    ContinuousScanCheckbox(module: module!),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
