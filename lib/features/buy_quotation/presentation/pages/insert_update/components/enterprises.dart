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
  final BuyQuotationEntity buyQuotation;
  final int code;
  const Enterprises({
    super.key,
    required this.enterpriseCode,
    required this.buyQuotation,
    required this.code,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        final currentList = buyQuotation.Enterprises ?? [];
        final currentEnterpriseIndex = currentList.indexWhere(
          (e) => e.enterprise.Code == enterprise.Code,
        );

        final updatedList = [...currentList];
        if (currentEnterpriseIndex == -1) {
          updatedList.add(enterprise.toBuyQuotationEnterprise());
        } else {
          final oldEnterprise = currentList[currentEnterpriseIndex];
          final isSelected =
              currentList[currentEnterpriseIndex].isSelected == true;
          final currentEnterprise = oldEnterprise.copyWith(
            isSelected: !isSelected,
          );
          updatedList[currentEnterpriseIndex] = currentEnterprise;
        }

        final updated = ref
            .read(
              completeBuyQuotationsStateControllerProvider(
                enterpriseCode,
                code.toString(),
              ).notifier,
            )
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

    return AsyncValueSliverWidget(
      value: ref.watch(enterprisesStateControllerProvider()),
      tryAgain: () => ref.invalidate(enterprisesStateControllerProvider()),
      data: (enterprises) {
        return SliverList.builder(
          itemCount: enterprises.length + 1,
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
            final enterprise = enterprises[index - 1];

            final isSelected =
                buyQuotation.Enterprises?.where(
                  (e) => e.enterprise.Code == enterprise.Code,
                ).toList().firstOrNull?.isSelected ==
                true;
            return Card(
              clipBehavior: Clip.antiAlias,
              color: isSelected ? theme.colorScheme.primaryContainer : null,
              child: InkWell(
                onTap: () => updateSelectedEnterprise(enterprise),
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
                        onChanged: (_) {
                          updateSelectedEnterprise(enterprise);
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
    );
  }
}
