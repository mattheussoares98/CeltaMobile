import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../../../../core/providers/services/services.dart';
import '../../../../enterprises/presentation/controllers/controllers.dart';

class SelectEnterpriseDropDown extends ConsumerWidget {
  const SelectEnterpriseDropDown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueWidget(
      value: ref.watch(enterprisesStateControllerProvider()),
      tryAgain: null,
      errorMaxLines: 1,
      data: (enterprises) {
        final theme = Theme.of(context);

        final items = enterprises
            .map((e) {
              // Keep it simple: a single Text is much cheaper than RichText/TextSpan
              final text =
                  '${e.PersonalizedCode} - ${e.name} (${e.CnpjNumber})';

              return DropdownMenuItem<EnterpriseEntity>(
                value: e,
                enabled: true,
                child: Text(
                  text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall,
                ),
              );
            })
            .toList(growable: false);

        return Consumer(
          builder: (context, ref, child) {
            final selectedEnterprise = ref.watch(
              selectedEnterpriseStateControllerProvider,
            );
            return RepaintBoundary(
              child: DefaultDropDown<EnterpriseEntity>(
                hint: Text('Selecione a empresa'.hardcoded),
                selectedItem: selectedEnterprise,
                label: selectedEnterprise != null
                    ? '${selectedEnterprise.PersonalizedCode} - ${selectedEnterprise.name}'
                    : null,
                onChanged: (enterprise) async {
                  ref
                      .read(selectedEnterpriseStateControllerProvider.notifier)
                      .selectEnterprise(enterprise);

                  final enterpriseName = ref.read(
                    userSessionProvider.select(
                      (s) => s.value?.enterprise?.name,
                    ),
                  );

                  if (kIsWeb ||
                      defaultTargetPlatform != TargetPlatform.iOS ||
                      defaultTargetPlatform != TargetPlatform.android) {
                    return;
                  }

                  ref.read(crashlyticsServiceProvider).setCustomKeys([
                    const CrashlyticsCustomKeyEntity(
                      key: 'DEBUG MODE',
                      value: 'IS DEBUG MODE',
                    ),
                    CrashlyticsCustomKeyEntity(
                      key: 'enterprise',
                      value: '$enterpriseName',
                    ),
                    CrashlyticsCustomKeyEntity(
                      key: 'selected_enterprise',
                      value: enterprise.name,
                    ),
                  ]);
                },
                items: items,
              ),
            );
          },
        );
      },
    );
  }
}
