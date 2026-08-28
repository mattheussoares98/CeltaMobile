import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

class PrintLabelLayoutFieldItem extends StatelessWidget {
  final BSFPrintLabelLayoutFieldEntity field;
  final BSFPrintLabelCoordinateUnit? coordinateUnit;

  const PrintLabelLayoutFieldItem({
    super.key,
    required this.field,
    required this.coordinateUnit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TitleAndSubTitle(
              title: 'Campo'.hardcoded,
              subTitle: field.field?.name,
              emptyMessage: 'Não informado'.hardcoded,
            ),
            if (field.field?.content.isNotEmpty == true)
              TitleAndSubTitle(
                title: 'Conteúdo'.hardcoded,
                subTitle: field.field!.content,
              ),
            TitleAndSubTitle(
              title: 'Coordenadas'.hardcoded,
              subTitle:
                  '${field.coordinateX}, ${field.coordinateY} $_coordinateUnit',
            ),
            if (field.dimensionType !=
                BSFPrintLabelFieldDimensionType.notApplicable)
              TitleAndSubTitle(
                title: 'Dimensões'.hardcoded,
                subTitle:
                    '${field.width} × ${field.height} $_dimensionDescription',
              ),
            if (field.fontType.isNotEmpty)
              TitleAndSubTitle(
                title: 'Fonte'.hardcoded,
                subTitle: '${field.fontType} (${field.fontSize})',
              ),
            if (field.prefix.isNotEmpty)
              TitleAndSubTitle(
                title: 'Prefixo'.hardcoded,
                subTitle: field.prefix,
              ),
          ],
        ),
      ),
    );
  }

  String get _coordinateUnit =>
      coordinateUnit == BSFPrintLabelCoordinateUnit.centimeter
      ? 'cm'
      : 'pontos'.hardcoded;

  String get _dimensionDescription => switch (field.dimensionType) {
    BSFPrintLabelFieldDimensionType.notApplicable => '',
    BSFPrintLabelFieldDimensionType.centimeter => 'cm',
    BSFPrintLabelFieldDimensionType.printerDot => 'pontos'.hardcoded,
    BSFPrintLabelFieldDimensionType.scaleFactor => 'fator'.hardcoded,
    BSFPrintLabelFieldDimensionType.printerCommandValue =>
      'valor do comando'.hardcoded,
  };
}
