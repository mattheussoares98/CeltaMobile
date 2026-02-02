import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../constants/constants.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../controllers/controllers.dart';
import '../../components/components.dart';
import '../../identification/components/components.dart';
import 'components.dart';

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
