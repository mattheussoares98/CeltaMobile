import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/enterprises/enterprises.dart';
import '../../../../../localization/string_hardcoded.dart';
import '../../../domain/entities/entities.dart';
import '../../controllers/controllers.dart';
import 'components/components.dart';

class EnterprisesPage extends ConsumerWidget {
  const EnterprisesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enterprisesAsync = ref.watch(enterprisesStateControllerProvider);

    void changeSelectedEnterprise(EnterpriseEntity enterprise) async {
      final moduleIsEnabled = await ref.read(
        moduleIsEnabledControllerProvider(
          Modules.buyRequest,
          enterprise.CnpjNumber!,
        ).future,
      );

      if (!moduleIsEnabled) {
        showAlertDialog(
          context: context,
          title: 'Módulo desabilitado'.hardcoded,
          content:
              'O módulo está desabilitado para essa empresa. Caso queira habilitar, entre em contato com o setor administrativo',
        );
        return;
      }

      final selectedEnterprises = ref.read(
        pendingBuyRequestStateControllerProvider.select(
          (s) => s.value?.selectedEnterprises,
        ),
      );
      final isSelected = selectedEnterprises?.contains(enterprise) ?? false;
      final updatedEnterprises = [...?selectedEnterprises];
      final Map<ProductKey, BuyRequestProductItemEntity> updatedProducts =
          Map.from(
            ref.read(
                  pendingBuyRequestStateControllerProvider.select(
                    (s) => s.value?.products,
                  ),
                ) ??
                {},
          );

      if (isSelected) {
        bool hasProductFromThisEnterpriseInserted = updatedProducts.keys.any(
          (k) => k.enterpriseCode == enterprise.Code,
        );

        if (hasProductFromThisEnterpriseInserted) {
          await showAlertDialog(
            context: context,
            title: 'Remover empresa?'.hardcoded,
            content:
                'Há produtos informados para essa empresa. Ao remover ela, os produtos serão removidos também'
                    .hardcoded,
            defaultActionText: 'Remover'.hardcoded,
            cancelActionText: 'Cancelar'.hardcoded,
            onOkPressed: () {
              updatedEnterprises.remove(enterprise);
              updatedProducts.removeWhere((key, value) {
                return key.enterpriseCode == enterprise.Code;
              });
            },
          );
        } else {
          updatedEnterprises.remove(enterprise);
        }
      } else {
        updatedEnterprises.add(enterprise);
      }

      ref
          .read(pendingBuyRequestStateControllerProvider.notifier)
          .updatePending(
            selectedEnterprises: updatedEnterprises,
            products: updatedProducts,
          );
    }

    return Scaffold(
      body: ResponsiveScrollableWidget(
        isSliverPage: true,
        child: AsyncValueWidget(
          value: enterprisesAsync,
          tryAgain: () {
            ref.invalidate(enterprisesStateControllerProvider);
          },
          data: (enterprises) {
            return ListView.builder(
              itemCount: enterprises.length,
              itemBuilder: (_, index) {
                final enterprise = enterprises[index];
                return EnterpriseItem(
                  key: ValueKey(enterprise.Code),
                  enterprise: enterprise,
                  onTap: () => changeSelectedEnterprise(enterprise),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
