import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../core/presentation/controllers/enterprises/enterprises.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../../../enterprises/presentation/controllers/controllers.dart';

class Enterprises extends ConsumerWidget {
  const Enterprises({super.key});

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
      }
    }

    return AsyncValueSliverWidget(
      value: ref.watch(enterprisesStateControllerProvider()),
      tryAgain: () => ref.invalidate(enterprisesStateControllerProvider()),
      data: (enterprises) {
        return SliverList.builder(
          itemCount: enterprises.length,
          itemBuilder: (_, index) {
            final enterprise = enterprises[index];
            return Card(
              clipBehavior: Clip.antiAlias,
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
                      //TODO create a DefaultCheckBox for the application and use here
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
