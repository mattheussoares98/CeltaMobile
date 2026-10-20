import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/enterprises/enterprises.dart';
import 'package:celta_inventario/features/buy_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/buy_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/buy_request/presentation/pages/create/enterprises/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EnterprisesPage extends ConsumerWidget {
  final int enterpriseCode;
  const EnterprisesPage({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void changeSelectedEnterprise(EnterpriseEntity enterprise) async {
      final moduleIsEnabled = await ref.read(
        moduleIsEnabledControllerProvider(
          Modules.buyRequest,
          enterprise.CnpjNumber!,
        ).future,
      );

      if (!moduleIsEnabled && context.mounted) {
        showAlertDialog(
          context: context,
          title: context.l10n.moduleDisabled,
          content: context.l10n.moduleDisabledContactAdmin,
        );
        return;
      }

      final selectedEnterprises = ref.read(
        pendingBuyRequestStateControllerProvider(
          enterpriseCode,
        ).select((s) => s.value?.selectedEnterprises),
      );
      final updatedEnterprises = [...?selectedEnterprises];
      final Map<ProductKey, BuyRequestProductItemEntity> updatedProducts =
          Map.from(
            ref.read(
                  pendingBuyRequestStateControllerProvider(
                    enterpriseCode,
                  ).select((s) => s.value?.products),
                ) ??
                {},
          );

      final isSelected =
          selectedEnterprises?.any((e) => e.Code == enterprise.Code) ?? false;
      if (isSelected) {
        bool hasProductFromThisEnterpriseInserted = updatedProducts.keys.any(
          (k) => k.enterpriseCode == enterprise.Code,
        );

        if (hasProductFromThisEnterpriseInserted) {
          if (!context.mounted) return;
          final result = await showAlertDialog(
            context: context,
            title: context.l10n.removeEnterpriseQuestion,
            content: context.l10n.removeEnterpriseProductsWarning,
            defaultActionText: context.l10n.remove,
            cancelActionText: context.l10n.cancel,
          );

          if (result == true && context.mounted) {
            updatedEnterprises.remove(enterprise);
            updatedProducts.removeWhere((key, value) {
              return key.enterpriseCode == enterprise.Code;
            });
          }
        } else {
          updatedEnterprises.remove(enterprise);
        }
      } else {
        updatedEnterprises.add(enterprise);
      }

      ref
          .read(
            pendingBuyRequestStateControllerProvider(enterpriseCode).notifier,
          )
          .updatePending(
            selectedEnterprises: updatedEnterprises,
            products: updatedProducts,
          );
    }

    return BaseScaffold(
      isScrollable: false,
      safeAreaTop: false,
      usePadding: false,
      body: Consumer(
        builder: (context, ref, child) {
          return AsyncValueWidget(
            value: ref.watch(
              buyRequestEnterprisesStateControllerProvider(enterpriseCode),
            ),
            tryAgain: () {
              ref.invalidate(
                buyRequestEnterprisesStateControllerProvider(enterpriseCode),
              );
            },
            data: (enterprises) {
              return ResponsiveListFlow(
                itemCount: enterprises.length,
                itemBuilder: (_, index) {
                  final enterprise = enterprises[index];
                  return EnterpriseItem(
                    key: ValueKey(enterprise.Code),
                    enterprise: enterprise,
                    enterpriseCode: enterpriseCode,
                    onTap: () => changeSelectedEnterprise(enterprise),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
