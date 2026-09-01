import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/pages/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

class PrintLabelLayoutFieldEditor extends StatelessWidget {
  final BSFPrintLabelLayoutFieldEntity field;
  final BSFPrintLabelCoordinateUnit? coordinateUnit;
  final ValueChanged<double> onCoordinateXChanged;
  final ValueChanged<double> onCoordinateYChanged;
  final ValueChanged<double> onWidthChanged;
  final ValueChanged<double> onHeightChanged;
  final ValueChanged<double> onRatioBarCodeChanged;
  final ValueChanged<BSFPrintElementRotationType> onRotationChanged;
  final ValueChanged<bool> onDrawLabelBelowBarcodeChanged;

  const PrintLabelLayoutFieldEditor({
    super.key,
    required this.field,
    required this.coordinateUnit,
    required this.onCoordinateXChanged,
    required this.onCoordinateYChanged,
    required this.onWidthChanged,
    required this.onHeightChanged,
    required this.onRatioBarCodeChanged,
    required this.onRotationChanged,
    required this.onDrawLabelBelowBarcodeChanged,
  });

  @override
  Widget build(BuildContext context) {
    const fastRepeatInterval = Duration(milliseconds: 25);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (field.field?.content.isNotEmpty == true)
          TitleAndSubTitle(
            title: 'Conteúdo'.hardcoded,
            subTitle: field.field!.content,
          ),
        gapH4,
        BaseText.title('Coordenadas ($_coordinateUnit)'.hardcoded),
        gapH4,
        Wrap(
          alignment: .spaceEvenly,
          runAlignment: .spaceEvenly,
          children: [
            PrintLabelLayoutValueAdjuster(
              label: 'X'.hardcoded,
              repeatInterval: fastRepeatInterval,
              value: _formatCoordinate(field.coordinateX),
              onDecrease: field.coordinateX > 0
                  ? () => onCoordinateXChanged(-_coordinateStep)
                  : null,
              onIncrease: () => onCoordinateXChanged(_coordinateStep),
            ),
            PrintLabelLayoutValueAdjuster(
              label: 'Y'.hardcoded,
              repeatInterval: fastRepeatInterval,
              value: _formatCoordinate(field.coordinateY),
              onDecrease: field.coordinateY > 0
                  ? () => onCoordinateYChanged(-_coordinateStep)
                  : null,
              onIncrease: () => onCoordinateYChanged(_coordinateStep),
            ),
          ],
        ),
        if (field.dimensionType !=
            BSFPrintLabelFieldDimensionType.notApplicable) ...[
          gapH8,
          BaseText.title('Dimensões ($_dimensionDescription)'.hardcoded),
          gapH4,
          Wrap(
            alignment: .spaceEvenly,
            runAlignment: .spaceEvenly,
            children: [
              PrintLabelLayoutValueAdjuster(
                label: 'Largura'.hardcoded,
                repeatInterval: fastRepeatInterval,
                value: _formatDimension(field.width),
                onDecrease: field.width > _minWidth
                    ? () => onWidthChanged(-_dimensionStep)
                    : null,
                onIncrease: () => onWidthChanged(_dimensionStep),
              ),
              PrintLabelLayoutValueAdjuster(
                label: 'Altura'.hardcoded,
                repeatInterval: fastRepeatInterval,
                value: _formatDimension(field.height),
                onDecrease: field.height > _minHeight
                    ? () => onHeightChanged(-_dimensionStep)
                    : null,
                onIncrease: () => onHeightChanged(_dimensionStep),
              ),
            ],
          ),
          if (field.field?.fieldType == BSFPrintLabelFieldType.boxOrLine) ...[
            gapH4,
            PrintLabelLayoutValueAdjuster(
              label: 'Espessura do traço'.hardcoded,
              value: _formatDimension(field.ratioBarCode),
              onDecrease: field.ratioBarCode > _minStrokeThickness
                  ? () => onRatioBarCodeChanged(-_dimensionStep)
                  : null,
              onIncrease: () => onRatioBarCodeChanged(_dimensionStep),
            ),
          ],
        ],
        gapH8,
        BaseText.title('Rotação'.hardcoded),
        gapH4,
        BaseSegmentedButtons<BSFPrintElementRotationType>(
          items: BSFPrintElementRotationType.values,
          selectedValue: field.rotateType,
          itemLabelBuilder: (item) => item.name,
          onChanged: onRotationChanged,
        ),
        if (field.field?.fieldType == BSFPrintLabelFieldType.barcode) ...[
          gapH8,
          BaseSwitch(
            title: 'Imprimir o texto abaixo do código de barras'.hardcoded,
            value: field.drawLabelBelowBarcode,
            onChanged: onDrawLabelBelowBarcodeChanged,
          ),
        ],
        if (field.fontType.isNotEmpty) ...[
          gapH4,
          TitleAndSubTitle(
            title: 'Fonte'.hardcoded,
            subTitle: '${field.fontType} (${field.fontSize})',
          ),
        ],
        if (field.prefix.isNotEmpty) ...[
          gapH4,
          TitleAndSubTitle(title: 'Prefixo'.hardcoded, subTitle: field.prefix),
        ],
      ],
    );
  }

  double get _coordinateStep =>
      coordinateUnit == BSFPrintLabelCoordinateUnit.centimeter ? 0.1 : 1.0;

  double get _dimensionStep => switch (field.dimensionType) {
    BSFPrintLabelFieldDimensionType.centimeter => 0.1,
    _ => 1.0,
  };

  String _formatCoordinate(double value) {
    if (coordinateUnit == BSFPrintLabelCoordinateUnit.centimeter) {
      return value.toStringAsFixed(1);
    }
    return value.truncateToDouble() == value
        ? value.toStringAsFixed(0)
        : value.toStringAsFixed(1);
  }

  String _formatDimension(double value) {
    if (field.dimensionType == BSFPrintLabelFieldDimensionType.centimeter) {
      return value.toStringAsFixed(1);
    }
    return value.truncateToDouble() == value
        ? value.toStringAsFixed(0)
        : value.toStringAsFixed(1);
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

  double get _minWidth {
    if (field.field?.fieldType == BSFPrintLabelFieldType.boxOrLine &&
        field.ratioBarCode > 0) {
      return field.ratioBarCode;
    }
    return field.dimensionType == BSFPrintLabelFieldDimensionType.centimeter
        ? 0.1
        : 1.0;
  }

  double get _minHeight => _minWidth;

  double get _minStrokeThickness => 1.0;
}
