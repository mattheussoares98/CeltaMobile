import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../constants/constants.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../controllers/controllers.dart';
import '../../components/components.dart';
import '../../identification/components/components.dart';
import 'components.dart';

class SelectedSupplier extends ConsumerWidget {
  const SelectedSupplier({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSupplier = ref.watch(
      pendingBuyRequestStateControllerProvider.select(
        (s) => s.value?.selectedSupplier,
      ),
    );

    if (selectedSupplier == null) {
      return UnselectedMessage(
        title: 'Nenhum fornecedor selecionado'.hardcoded,
      );
    }

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DefaultSmallTitle(title: 'Fornecedor'.hardcoded),
          SupplierItem(
            supplier: selectedSupplier,
            enabled: false,
            onTap: () {},
          ),
          gapH8,
        ],
      ),
    );
  }
}
