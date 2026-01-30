import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../core/presentation/controllers/enterprises/enterprises.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../../../enterprises/presentation/controllers/controllers.dart';
import '../../../../domain/entities/entities.dart';
import '../../../controllers/controller.dart';

class Enterprises extends ConsumerWidget {
  final int enterpriseCode;
  final int code;
  const Enterprises({
    super.key,
    required this.enterpriseCode,
    required this.code,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = completeBuyQuotationsStateControllerProvider(
      enterpriseCode,
      code.toString(),
    );
    final buyQuotationEnterprises =
        ref.watch(provider.select((s) => s.value?.Enterprises)) ?? [];

    void updateSelectedEnterprise(EnterpriseEntity enterprise) async {
      bool moduleIsEnabled = await ref.read(
        moduleIsEnabledControllerProvider(
          Modules.buyQuotation,
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
      } else {
        final enterpriseToUpdate = buyQuotationEnterprises.firstWhereOrNull(
          (e) => e.enterprise.Code == enterprise.Code,
        );

        final updatedList = [...buyQuotationEnterprises];
        if (enterpriseToUpdate == null) {
          updatedList.add(enterprise.toBuyQuotationEnterprise());
        } else {
          final isSelected = enterpriseToUpdate.isSelected == true;
          final currentEnterprise = enterpriseToUpdate.copyWith(
            isSelected: !isSelected,
          );
          updatedList
            ..remove(enterpriseToUpdate)
            ..add(currentEnterprise);
        }

        final updated = ref
            .read(provider.notifier)
            .updateValues(Enterprises: updatedList);
        if (!updated) {
          showAlertDialog(
            context: context,
            title: 'Erro'.hardcoded,
            content:
                'Não foi possível atualizar as empresas. Entre em contato com o suporte.'
                    .hardcoded,
          );
        }
      }
    }

    final theme = Theme.of(context);

    return AsyncValueWidget(
      isSliver: true,
      value: ref.watch(enterprisesStateControllerProvider()),
      tryAgain: () => ref.invalidate(enterprisesStateControllerProvider()),
      data: (enterprises) {
        final filteredEnterprises = code == 0
            ? enterprises
            : enterprises
                  //cant allow the user to insert a new enterprise because causes error
                  .where(
                    (e) => buyQuotationEnterprises.any(
                      (x) => x.enterprise.Code == e.Code,
                    ),
                  )
                  .toList();
        return SliverList.builder(
          itemCount: filteredEnterprises.length + 1,
          itemBuilder: (_, index) {
            if (index == 0) {
              return Text(
                'Empresas'.hardcoded,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: theme.primaryColor,
                ),
              );
            }
            final enterprise = filteredEnterprises[index - 1];

            final isSelected =
                buyQuotationEnterprises
                    .firstWhereOrNull(
                      (e) => e.enterprise.Code == enterprise.Code,
                    )
                    ?.isSelected ==
                true;

            return _EnterpriseItem(
              key: ValueKey(enterprise.Code),
              updateSelectedEnterprise: () =>
                  updateSelectedEnterprise(enterprise),
              enterprise: enterprise,
              isSelected: isSelected,
            );
          },
        );
      },
    );
  }
}

class _EnterpriseItem extends StatelessWidget {
  final VoidCallback updateSelectedEnterprise;
  final EnterpriseEntity enterprise;
  final bool isSelected;

  const _EnterpriseItem({
    super.key,
    required this.updateSelectedEnterprise,
    required this.enterprise,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: updateSelectedEnterprise,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              Sizes.p8,
              Sizes.p8,
              0, //because of the CheckBox
              Sizes.p8,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleAndSubTitle(
                        title: 'Código'.hardcoded,
                        subTitle: enterprise.PersonalizedCode.toString(),
                      ),
                      TitleAndSubTitle(
                        title: 'Empresa'.hardcoded,
                        subTitle: enterprise.name,
                      ),
                      TitleAndSubTitle(
                        title: 'CNPJ'.hardcoded,
                        subTitle: enterprise.CnpjNumber,
                      ),
                    ],
                  ),
                ),
                Checkbox(
                  value: isSelected,
                  onChanged: (_) => updateSelectedEnterprise(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
