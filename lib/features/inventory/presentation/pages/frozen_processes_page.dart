import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../constants/constants.dart';
import '../../../../core/domain/entities/entities.dart';
import '../../../../routing/routing.dart';
import '../controllers/controllers.dart';

class FrozenProcessesPage extends ConsumerWidget {
  final int enterpriseCode;
  final EnterpriseEntity? selectedEnterprise;
  const FrozenProcessesPage({
    super.key,
    required this.enterpriseCode,
    required this.selectedEnterprise,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(
      inventoryStateControllerProvider(
        enterpriseCode,
        selectedEnterprise?.name ?? '',
      ),
    );
    final dateFormatter = DateFormat('dd/MM/yyyy HH:mm');
    return Scaffold(
      appBar: AppBar(title: Text('Processos congelados'.hardcoded)),
      body: AsyncValueWidget(
        value: value,
        tryAgain: () {
          ref.invalidate(
            inventoryStateControllerProvider(
              enterpriseCode,
              selectedEnterprise?.name ?? '',
            ),
          );
        },
        data: (inventories) {
          return ResponsiveListFlow(
            itemCount: inventories?.frozenProcesses.length ?? 0,
            itemBuilder: (_, index) {
              final frozenProcess = inventories!.frozenProcesses[index];

              return Card(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    context.goNamed(
                      Routes.inventoryCountings.name,
                      pathParameters: {
                        'enterpriseCode': enterpriseCode.toString(),
                        'codigoInternoInventario':
                            frozenProcess.CodigoInternoInventario.toString(),
                      },
                      extra: {
                        'enterprise': selectedEnterprise,
                        'counting': inventories.countings
                            .where(
                              (e) =>
                                  frozenProcess.CodigoInternoInventario ==
                                  e.CodigoInternoInventario,
                            )
                            .toList(),
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(Sizes.p8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleAndSubTitle(
                          title: 'Empresa'.hardcoded,
                          subTitle: frozenProcess.NomeEmpresa,
                        ),
                        TitleAndSubTitle(
                          title: 'Tipo de estoque'.hardcoded,
                          subTitle: frozenProcess.NomeTipoEstoque,
                        ),
                        TitleAndSubTitle(
                          title: 'Responsável'.hardcoded,
                          subTitle: frozenProcess.NomeFuncionario,
                        ),
                        TitleAndSubTitle(
                          title: 'Criado em'.hardcoded,
                          subTitle: dateFormatter.format(
                            frozenProcess.CataCriacaoInventario,
                          ),
                        ),
                        TitleAndSubTitle(
                          title: 'Congelado em'.hardcoded,
                          subTitle: dateFormatter.format(
                            frozenProcess.DataCongelamentoInventario,
                          ),
                        ),

                        TitleAndSubTitle(
                          title: frozenProcess.ObsInventario == null
                              ? 'Sem observações'.hardcoded
                              : 'Observações'.hardcoded,
                          subTitle: frozenProcess.ObsInventario,
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
    );
  }
}
