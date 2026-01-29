import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../controllers/controllers.dart';
import '../../enterprises/components/components.dart';

class SelectedEnterprise extends ConsumerWidget {
  const SelectedEnterprise({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedEnterprises = ref.watch(
      pendingBuyRequestStateControllerProvider.select(
        (s) => s.value?.selectedEnterprises,
      ),
    );

    return ResponsiveListFlow(
      isSliver: true,
      itemCount: selectedEnterprises?.length ?? 0,
      itemBuilder: (_, index) {
        final enterprise = selectedEnterprises![index];

        return EnterpriseItem(enterprise: enterprise, onTap: null);
      },
    );
  }
}
