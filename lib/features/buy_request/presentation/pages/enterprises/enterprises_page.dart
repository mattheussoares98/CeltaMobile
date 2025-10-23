import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../domain/entities/entities.dart';
import '../../controllers/controllers.dart';

class EnterprisesPage extends ConsumerWidget {
  const EnterprisesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enterprisesAsync = ref.watch(enterprisesStateControllerProvider);
    final pendingAsync = ref.watch(pendingBuyRequestStateControllerProvider);

    void changeSelectedEnterprise(EnterpriseEntity enterprise) async {
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
            (pendingAsync.value ?? PendingBuyRequestEntity.empty()).copyWith(
              selectedEnterprises: selectedEnterprises,
              products: products,
            ),
          );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Empresas'.hardcoded)),
      body: ResponsiveScrollableWidget(
        isSliverPage: true, //TODO change this param name
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
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
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
                          Checkbox(
                            value:
                                pendingAsync.value?.selectedEnterprises
                                    ?.contains(enterprise) ??
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
              },
            );
          },
        ),
      ),
    );
  }
}
