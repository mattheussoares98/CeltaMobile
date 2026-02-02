import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../localization/string_hardcoded.dart';
import '../../../controllers/controllers.dart';
import '../../components/components.dart';
import 'components.dart';

class SelectedEnterprisesQuantity extends ConsumerWidget {
  final int enterpriseCode;
  const SelectedEnterprisesQuantity({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enterprisesLength = ref.watch(
      pendingBuyRequestStateControllerProvider(
        enterpriseCode,
      ).select((s) => s.value?.selectedEnterprises?.length ?? 0),
    );

    if (enterprisesLength == 0) {
      return UnselectedMessage(
        title: 'Selecione pelo menos uma empresa'.hardcoded,
      );
    }
    return SliverToBoxAdapter(
      child: DefaultSmallTitle(
        title: 'Empresas ($enterprisesLength)'.hardcoded,
      ),
    );
  }
}
