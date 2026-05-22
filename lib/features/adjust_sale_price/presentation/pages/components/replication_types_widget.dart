import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/adjust_sale_price/domain/entities/entities.dart';
import 'package:celta_inventario/features/adjust_sale_price/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/adjust_sale_price/presentation/pages/components/components.dart';

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

    return AsyncValueWidget(
      value: ref.watch(uIStateControllerProvider(plu)),
      tryAgain: () => ref.invalidate(uIStateControllerProvider(plu)),
      data: (uiState) {
        return Column(
          children: [
            TitleWidget(title: 'Parâmetros de replicação'.hardcoded),
            ...?availableReplications?.map((replication) {
              return RepaintBoundary(
                child: DefaultCheckBox(
                  name: replication.name,
                  enabled:
                      uiState.selectedReplications.contains(replication) ==
                      true,
                  onChanged: (_) => onChanged(replication),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}
