import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../controllers/controllers.dart';
import 'components/components.dart';

class FrozenProcessesPage extends ConsumerWidget {
  final int enterpriseCode;
  const FrozenProcessesPage({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Processos congelados'.hardcoded)),
      body: AsyncValueWidget(
        value: ref.watch(inventoryStateControllerProvider(enterpriseCode)),
        tryAgain: () {
          ref.invalidate(inventoryStateControllerProvider(enterpriseCode));
        },
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
      ),
    );
  }
}
