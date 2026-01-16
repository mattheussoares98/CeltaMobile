import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../core/presentation/controllers/enterprises/enterprises.dart';
import '../../../controllers/controllers.dart';

class EnterpriseItem extends ConsumerWidget {
  final bool? enabled;
  final EnterpriseEntity enterprise;
  const EnterpriseItem({
    super.key,
    required this.enterprise,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingAsync = ref.watch(pendingBuyRequestStateControllerProvider);

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

      final isSelected =
          pendingAsync.value?.selectedEnterprises?.contains(enterprise) ??
          false;

      final selectedEnterprises = [...?pendingAsync.value?.selectedEnterprises];
      final products = pendingAsync.value?.products ?? {};

      if (isSelected) {
        final productsMap = pendingAsync.value?.products;
        bool hasProductFromThisEnterpriseInserted =
            productsMap?.keys.any((k) => k.enterpriseCode == enterprise.Code) ??
            false;

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
              selectedEnterprises.remove(enterprise);
              products.removeWhere((key, value) {
                return key.enterpriseCode == enterprise.Code;
              });
            },
          );
        } else {
          selectedEnterprises.remove(enterprise);
        }
      } else {
        selectedEnterprises.add(enterprise);
      }

      ref
          .read(pendingBuyRequestStateControllerProvider.notifier)
          .updatePending(
            selectedEnterprises: selectedEnterprises,
            products: products,
          );
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: enabled == false
            ? null
            : () {
                changeSelectedEnterprise(enterprise);
              },
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p8),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TitleAndSubTitle(
                      title: null,
                      subTitle:
                          '${enterprise.PersonalizedCode} - ${enterprise.name}',
                    ),
                    TitleAndSubTitle(
                      title: 'Nome fantasia'.hardcoded,
                      subTitle: enterprise.FantasizesName,
                    ),
                    TitleAndSubTitle(
                      title: 'CNPJ'.hardcoded,
                      subTitle: enterprise.CnpjNumber,
                    ),
                  ],
                ),
              ),
              if (enabled == true)
                Checkbox(
                  value:
                      pendingAsync.value?.selectedEnterprises?.contains(
                        enterprise,
                      ) ??
                      false,
                  onChanged: (_) {
                    changeSelectedEnterprise(enterprise);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
