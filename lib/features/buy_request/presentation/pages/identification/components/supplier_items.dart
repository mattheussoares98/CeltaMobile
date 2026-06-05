import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/supplier/supplier.dart';
import 'package:celta_inventario/features/buy_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/buy_request/presentation/pages/identification/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SupplierItems extends ConsumerWidget {
  final bool isSliver;
  final int enterpriseCode;
  const SupplierItems({
    super.key,
    required this.isSliver,
    required this.enterpriseCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onTap(SupplierEntity? supplier) async {
      final selectedSupplier = ref.read(
        pendingBuyRequestStateControllerProvider(
          enterpriseCode,
        ).select((s) => s.value?.selectedSupplier),
      );
      final pendingRequest = await ref.read(
        pendingBuyRequestStateControllerProvider(enterpriseCode).future,
      );
      final hasSelectedEnterprisesOrProducts =
          (pendingRequest.selectedEnterprises?.isNotEmpty ?? false) ||
          (pendingRequest.products?.isNotEmpty ?? false);

      if (hasSelectedEnterprisesOrProducts) {
        if (!context.mounted) return;
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
                .read(
                  pendingBuyRequestStateControllerProvider(
                    enterpriseCode,
                  ).notifier,
                )
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
            .read(
              pendingBuyRequestStateControllerProvider(enterpriseCode).notifier,
            )
            .updatePending(
              selectedSupplier: supplier,
              annulSelectedEnterprises: true,
              annulProducts: true,
              annulSelectedSupplier: selectedSupplier == supplier,
            );
      }
    }

    return AsyncValueWidget(
      isSliver: true,
      value: ref.watch(
        supplierStateControllerProvider(
          SearchSupplierType.buyRequest,
          enterpriseCode,
        ),
      ),
      data: (suppliers) => _Items(
        key: const ValueKey('sliver'),
        suppliers: suppliers,
        isSliver: isSliver,
        onTap: onTap,
        enterpriseCode: enterpriseCode,
      ),
      tryAgain: null,
    );
  }
}

class _Items extends StatelessWidget {
  final List<SupplierEntity>? suppliers;
  final bool isSliver;
  final void Function(SupplierEntity? supplier) onTap;
  final int enterpriseCode;
  const _Items({
    super.key,
    required this.suppliers,
    required this.isSliver,
    required this.onTap,
    required this.enterpriseCode,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveListFlow(
      isSliver: isSliver,
      itemCount: suppliers?.length ?? 0,
      // maxItemWidth: 400,
      itemBuilder: (_, index) {
        final supplier = suppliers![index];
        return SupplierItem(
          key: ValueKey(supplier.Code),
          supplier: supplier,
          onTap: () => onTap(supplier),
          enterpriseCode: enterpriseCode,
        );
      },
    );
  }
}
