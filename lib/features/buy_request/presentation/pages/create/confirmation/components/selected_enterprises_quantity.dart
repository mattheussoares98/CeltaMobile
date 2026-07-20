import 'package:celta_inventario/features/buy_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/buy_request/presentation/pages/create/components/components.dart';
import 'package:celta_inventario/features/buy_request/presentation/pages/create/confirmation/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
