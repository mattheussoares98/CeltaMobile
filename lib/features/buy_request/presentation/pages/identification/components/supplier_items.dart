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
    final hasSelectedEnterprisesOrProducts = ref.watch(
      pendingBuyRequestStateControllerProvider.select(
        (s) =>
            (s.value?.selectedEnterprises?.isNotEmpty ?? false) ||
            (s.value?.products?.isNotEmpty ?? false),
      ),
    );

    void onTap(SupplierEntity? supplier) {
      final selectedSupplier = ref.read(
        pendingBuyRequestStateControllerProvider.select(
          (s) => s.value?.selectedSupplier,
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

    final suppliersAsync = ref.watch(
      supplierStateControllerProvider(SearchSupplierType.buyRequest),
    );
    final hasSelectedSupplier = ref.read(
      pendingBuyRequestStateControllerProvider.select(
        (s) => s.value?.selectedSupplier != null,
      ),
    );

    if (hasSelectedSupplier && (suppliersAsync.value?.isEmpty ?? true)) {
      return SliverList.builder(
        itemCount: 1,
        itemBuilder: (_, index) {
          final supplier = ref.read(
            pendingBuyRequestStateControllerProvider.select(
              (s) => s.value?.selectedSupplier,
            ),
          );
          return SupplierItem(
            key: ValueKey(supplier?.Code),
            supplier: supplier!,
            onTap: () => onTap(supplier),
            enabled: true,
          );
        },
      );
    }

    return AsyncValueSliverWidget(
      value: suppliersAsync,
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
