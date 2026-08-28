import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';

class PrintLabelLayoutGeneralInformation extends StatelessWidget {
  final BSFPrintLabelLayoutEntity layout;

  const PrintLabelLayoutGeneralInformation({super.key, required this.layout});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TitleAndSubTitle(
              title: 'Nome'.hardcoded,
              subTitle: layout.name,
              subTitleStyle: context.theme.textTheme.titleMedium,
            ),
            TitleAndSubTitle(title: 'Código'.hardcoded, subTitle: layout.code),
            TitleAndSubTitle(
              title: 'Tipo'.hardcoded,
              subTitle: _layoutTypeDescription,
            ),
            TitleAndSubTitle(
              title: 'Formulário'.hardcoded,
              subTitle: _formTypeDescription,
            ),
            TitleAndSubTitle(
              title: 'Tamanho do formulário'.hardcoded,
              subTitle: '${layout.formWidth} × ${layout.formHeight}',
            ),
            TitleAndSubTitle(
              title: 'Tamanho da etiqueta'.hardcoded,
              subTitle: '${layout.labelWidth} × ${layout.labelHeight}',
            ),
            TitleAndSubTitle(
              title: 'Quantidade de colunas'.hardcoded,
              subTitle: layout.quantityColumns,
            ),
            TitleAndSubTitle(
              title: 'Impressora'.hardcoded,
              subTitle: layout.labelPrinter?.description,
              emptyMessage: 'Não informada'.hardcoded,
            ),
          ],
        ),
      ),
    );
  }

  String get _formTypeDescription =>
      layout.formType == BSFPrintLabelFormType.paginated
      ? 'Paginado'.hardcoded
      : 'Contínuo'.hardcoded;

  String get _layoutTypeDescription => switch (layout.layoutType) {
    BSFPrintLabelLayoutType.customer => 'Cliente'.hardcoded,
    BSFPrintLabelLayoutType.covenant => 'Convênio'.hardcoded,
    BSFPrintLabelLayoutType.product => 'Produto'.hardcoded,
    BSFPrintLabelLayoutType.customerCard => 'Cartão de cliente'.hardcoded,
    BSFPrintLabelLayoutType.saleBilling => 'Faturamento'.hardcoded,
    BSFPrintLabelLayoutType.transport => 'Transporte'.hardcoded,
    BSFPrintLabelLayoutType.saleRequestProduct =>
      'Produto do pedido de venda'.hardcoded,
  };
}
