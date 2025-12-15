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
  final int buyQuotationCode;
  final BuyQuotationEntity buyQuotation;
  const Enterprises({
    super.key,
    required this.enterpriseCode,
    required this.buyQuotationCode,
    required this.buyQuotation,
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
        final existingEnterprise = currentList.firstWhereOrNull(
          (e) => e.enterprise.Code == enterprise.Code,
        );

        final List<BuyQuotationEnterpriseEntity> updatedList;

        if (existingEnterprise != null) {
          // Enterprise exists, so REMOVE it
          updatedList = currentList
              .where((e) => e.enterprise.Code != enterprise.Code)
              .toList();
        } else {
          // Enterprise does not exist, so ADD it (after mapping)
          final newEnterprise = enterprise.toBuyQuotationEnterprise();
          updatedList = [...currentList, newEnterprise];
        }

        ref
            .read(
              completeBuyQuotationsStateControllerProvider(
                enterpriseCode,
                buyQuotationCode.toString(),
              ).notifier,
            )
            .updateValues(Enterprises: updatedList);
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
            return Card(
              clipBehavior: Clip.antiAlias,
              color:
                  buyQuotation.Enterprises?.any(
                        (e) => e.enterprise.Code == enterprise.Code,
                      ) ==
                      true
                  ? theme.colorScheme.primaryContainer
                  : null,
              child: InkWell(
                onTap: () {
                  updateSelectedEnterprise(enterprise);
                },
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
                              subTitle: enterprise.Code.toString(),
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
                        value:
                            buyQuotation.Enterprises?.any(
                              (e) => e.enterprise.Code == enterprise.Code,
                            ) ??
                            false,
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
