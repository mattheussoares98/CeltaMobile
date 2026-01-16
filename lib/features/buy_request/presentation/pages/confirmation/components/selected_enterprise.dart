import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../localization/string_hardcoded.dart';
import '../../../controllers/controllers.dart';
import '../../components/components.dart';
import '../../enterprises/components/components.dart';
import 'components.dart';

class SelectedEnterprise extends ConsumerWidget {
  const SelectedEnterprise({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedEnterprises = ref.watch(
      pendingBuyRequestStateControllerProvider.select(
        (s) => s.value?.selectedEnterprises,
      ),
    );

    if (selectedEnterprises?.isEmpty ?? true) {
      return UnselectedMessage(title: 'Nenhuma empresa selecionada'.hardcoded);
    }

    return SliverList.builder(
      itemCount: selectedEnterprises!.length + 1,
      itemBuilder: (_, index) {
        if (index == 0) {
          return DefaultSmallTitle(
            title: 'Empresas (${selectedEnterprises.length})'.hardcoded,
          );
        }
        final enterprise = selectedEnterprises[index - 1];

        return EnterpriseItem(
          enterprise: enterprise,
          enabled: false,
          onTap: () {},
        );
      },
    );
  }
}
