import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../core/presentation/controllers/supplier/supplier.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../controllers/controllers.dart';
import 'components.dart';

class SupplierItems extends ConsumerWidget {
  const SupplierItems({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onTap(SupplierEntity? supplier) async {
      final selectedSupplier = ref.read(
        pendingBuyRequestStateControllerProvider.select(
          (s) => s.value?.selectedSupplier,
        ),
      );
      final hasSelectedEnterprisesOrProducts = await ref.read(
        pendingBuyRequestStateControllerProvider.selectAsync(
          (s) =>
              (s.selectedEnterprises?.isNotEmpty ?? false) ||
              (s.products?.isNotEmpty ?? false),
        ),
      );

      if (hasSelectedEnterprisesOrProducts) {
        showAlertDialog(
          context: context,
          title: 'Alterar fornecedor?'.hardcoded,
          defaultActionText: 'Sim'.hardcoded,
          cancelActionText: 'Cancelar'.hardcoded,
          content:
              'Ao alterar o fornecedor, todas empresas e produtos selecionados serão removidos'
                  .hardcoded,
          onOkPressed: () {
            ref
                .read(pendingBuyRequestStateControllerProvider.notifier)
                .updatePending(
                  selectedSupplier: supplier,
                  annulSelectedEnterprises: true,
                  annulProducts: true,
                  annulSelectedSupplier: selectedSupplier == supplier,
                );
          },
        );
      } else {
        ref
            .read(pendingBuyRequestStateControllerProvider.notifier)
            .updatePending(
              selectedSupplier: supplier,
              annulSelectedEnterprises: true,
              annulProducts: true,
              annulSelectedSupplier: selectedSupplier == supplier,
            );
      }
    }

    return AsyncValueSliverWidget(
      value: ref.watch(
        supplierStateControllerProvider(SearchSupplierType.buyRequest),
      ),
      data: (suppliers) {
        return SliverList.builder(
          itemCount: suppliers?.length ?? 0,
          itemBuilder: (_, index) {
            final supplier = suppliers![index];
            return SupplierItem(
              key: ValueKey(supplier.Code),
              supplier: supplier,
              onTap: () => onTap(supplier),
              enabled: true,
            );
          },
        );
      },
      tryAgain: null,
    );
  }
}
