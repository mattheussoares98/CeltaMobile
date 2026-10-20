import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/inventory/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/inventory/presentation/pages/frozen_process/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FrozenProcessesPage extends ConsumerWidget {
  final int enterpriseCode;
  const FrozenProcessesPage({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> onRefresh() async {
      ref.invalidate(inventoryStateControllerProvider(enterpriseCode));
    }

    return BaseScaffold(
      isScrollable: false,
      refreshProvider: inventoryStateControllerProvider(enterpriseCode),
      appBar: BaseAppBar(
        title: context.l10n.frozenProcesses,
        selectedEnterpriseCode: enterpriseCode,
      ),
      body: Consumer(
        builder: (context, ref, child) {
          return AsyncValueWidget(
            value: ref.watch(inventoryStateControllerProvider(enterpriseCode)),
            tryAgain: onRefresh,
            data: (inventories) {
              return ResponsiveListFlow(
                itemCount: inventories?.frozenProcesses.length ?? 0,
                itemBuilder: (_, index) {
                  final frozenProcess = inventories!.frozenProcesses[index];

                  return FrozenItem(
                    key: ValueKey(frozenProcess.CodigoInternoInventario),
                    frozenProcess: frozenProcess,
                    inventories: inventories,
                    enterpriseCode: enterpriseCode,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
