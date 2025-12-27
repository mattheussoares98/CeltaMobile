import 'package:celta_intelligence/features/adjust_sale_price/presentation/controllers/ui_state_controller.dart';
import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../domain/entities/entities.dart';
import 'components.dart';

class ReplicationTypesWidget extends ConsumerWidget {
  final String plu;
  const ReplicationTypesWidget({super.key, required this.plu});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final availableReplications = ref.watch(
      uIStateControllerProvider(
        plu,
      ).select((s) => s.value?.availableReplications),
    );

    void onChanged(ReplicationTypes? replication) {
      ref
          .read(uIStateControllerProvider(plu).notifier)
          .updateValues(selectedReplication: replication);
    }

    final theme = Theme.of(context);

    return AsyncValueWidget(
      value: ref.watch(uIStateControllerProvider(plu)),
      tryAgain: () => ref.invalidate(uIStateControllerProvider(plu)),
      data: (uiState) {
        return Column(
          children: [
            TitleWidget(title: 'Parâmetros de replicação'.hardcoded),
            ...?availableReplications?.map((replication) {
              if (theme.platform == TargetPlatform.iOS) {
                return CupertinoListTile(
                  padding: EdgeInsets.zero,
                  title: Text(
                    replication.name,
                    style: theme.textTheme.bodyMedium,
                  ),
                  trailing: CupertinoSwitch(
                    value:
                        uiState.selectedReplications.contains(replication) ==
                        true,
                    onChanged: (_) => onChanged(replication),
                  ),
                  onTap: () => onChanged(replication),
                );
              } else {
                return CheckboxListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: Sizes.p8,
                  ),
                  title: Text(
                    replication.name,
                    style: theme.textTheme.bodyMedium,
                  ),
                  value: uiState.selectedReplications.contains(replication),
                  onChanged: (_) => onChanged(replication),
                  dense: true,
                );
              }
            }),
          ],
        );
      },
    );
  }
}
