import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../constants/constants.dart';
import '../../../../core/domain/entities/entities.dart';
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
          return ListView.builder(
            itemCount: inventories?.frozenProcesses.length ?? 0,
            itemBuilder: (_, index) {
              final frozenProcess = inventories!.frozenProcesses[index];

              return Card(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    //TODO implement navigation to countings page
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(Sizes.p8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleAndSubTitle(
                          title: 'Empresa',
                          subTitle: frozenProcess.NomeEmpresa,
                        ),
                        TitleAndSubTitle(
                          title: 'Tipo de estoque',
                          subTitle: frozenProcess.NomeTipoEstoque,
                        ),
                        TitleAndSubTitle(
                          title: 'Responsável',
                          subTitle: frozenProcess.NomeFuncionario,
                        ),
                        TitleAndSubTitle(
                          title: 'Criado em',
                          subTitle: dateFormatter.format(
                            frozenProcess.CataCriacaoInventario,
                          ),
                        ),
                        TitleAndSubTitle(
                          title: 'Congelado em',
                          subTitle: dateFormatter.format(
                            frozenProcess.DataCongelamentoInventario,
                          ),
                        ),
                        if (frozenProcess.ObsInventario != null)
                          TitleAndSubTitle(
                            title: 'Observações',
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
