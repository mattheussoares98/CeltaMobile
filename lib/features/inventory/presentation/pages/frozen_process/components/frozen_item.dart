import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/inventory/domain/entities/entities.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FrozenItem extends StatelessWidget {
  final FrozenProcessEntity frozenProcess;
  final InventoryEntity inventories;
  final int enterpriseCode;
  const FrozenItem({
    super.key,
    required this.frozenProcess,
    required this.inventories,
    required this.enterpriseCode,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Card(
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
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(Sizes.p8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleAndSubTitle(
                  title: 'Empresa'.hardcoded,
                  subTitle:
                      '${frozenProcess.CodigoEmpresa} - ${frozenProcess.NomeEmpresa}',
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
                  subTitle: frozenProcess.CataCriacaoInventario.formatDate(
                    DateFormatType.ddMMyyyyHHmm,
                  ),
                ),
                TitleAndSubTitle(
                  title: 'Congelado em'.hardcoded,
                  subTitle: frozenProcess.DataCongelamentoInventario.formatDate(
                    DateFormatType.ddMMyyyyHHmm,
                  ),
                ),

                TitleAndSubTitle(
                  title: frozenProcess.ObsInventario == null
                      ? 'Sem observações'.hardcoded
                      : 'Observações'.hardcoded,
                  subTitle: frozenProcess.ObsInventario,
                  removeColon: frozenProcess.ObsInventario?.isEmpty ?? true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
