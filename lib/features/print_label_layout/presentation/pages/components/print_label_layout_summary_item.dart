import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';

class PrintLabelLayoutSummaryItem extends StatelessWidget {
  final BSFPrintLabelLayoutSummaryEntity summary;

  const PrintLabelLayoutSummaryItem({super.key, required this.summary});

  String get _printerDescription {
    final description = summary.labelPrinterDescription;
    return description?.isNotEmpty == true
        ? description!
        : summary.labelPrinterModelType.apiValue;
  }

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
              subTitle: summary.name,
              subTitleStyle: context.theme.textTheme.titleMedium,
            ),
            TitleAndSubTitle(title: 'Código'.hardcoded, subTitle: summary.code),
            TitleAndSubTitle(
              title: 'Tipo'.hardcoded,
              subTitle: summary.layoutTypeDescription,
            ),
            TitleAndSubTitle(
              title: 'Formulário'.hardcoded,
              subTitle: summary.formType.description,
            ),
            TitleAndSubTitle(
              title: 'Impressora'.hardcoded,
              subTitle: _printerDescription,
            ),
            TitleAndSubTitle(
              title: 'Unidade das coordenadas'.hardcoded,
              subTitle: summary.coordinateUnit.description,
            ),
          ],
        ),
      ),
    );
  }
}
