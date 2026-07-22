import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/buy_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/buy_request/presentation/pages/create/enterprises/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedEnterprise extends ConsumerWidget {
  final int enterpriseCode;
  const SelectedEnterprise({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedEnterprises = ref.watch(
      pendingBuyRequestStateControllerProvider(
        enterpriseCode,
      ).select((s) => s.value?.selectedEnterprises),
    );

    return ResponsiveListFlow(
      isSliver: true,
      itemCount: selectedEnterprises?.length ?? 0,
      padding: EdgeInsets.zero,
      itemBuilder: (_, index) {
        final enterprise = selectedEnterprises![index];

        return EnterpriseItem(
          enterprise: enterprise,
          onTap: null,
          enterpriseCode: enterpriseCode,
        );
      },
    );
  }
}
