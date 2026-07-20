import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/buy_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/buy_request/presentation/pages/create/components/components.dart';
import 'package:celta_inventario/features/buy_request/presentation/pages/create/confirmation/components/components.dart';
import 'package:celta_inventario/features/buy_request/presentation/pages/create/identification/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedSupplier extends ConsumerWidget {
  final int enterpriseCode;
  const SelectedSupplier({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSupplier = ref.watch(
      pendingBuyRequestStateControllerProvider(
        enterpriseCode,
      ).select((s) => s.value?.selectedSupplier),
    );

    if (selectedSupplier == null) {
      return UnselectedMessage(title: 'Selecione um fornecedor'.hardcoded);
    }

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DefaultSmallTitle(title: 'Fornecedor'.hardcoded),
          SupplierItem(
            supplier: selectedSupplier,
            onTap: null,
            enterpriseCode: enterpriseCode,
          ),
          gapH8,
        ],
      ),
    );
  }
}
