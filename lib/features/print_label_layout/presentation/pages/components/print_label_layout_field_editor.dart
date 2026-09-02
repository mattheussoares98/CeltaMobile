import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/pages/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class PrintLabelLayoutFieldEditor extends HookConsumerWidget {
  final int layoutCode;
  final BSFPrintLabelLayoutFieldEntity field;
  final List<BSFPrintLabelFieldFormatEntity> formats;
  final BSFPrintLabelCoordinateUnit? coordinateUnit;
  final ValueChanged<double> onCoordinateXChanged;
  final ValueChanged<double> onCoordinateYChanged;
  final ValueChanged<double> onWidthChanged;
  final ValueChanged<double> onHeightChanged;
  final ValueChanged<double> onRatioBarCodeChanged;
  final ValueChanged<BSFPrintElementRotationType> onRotationChanged;
  final ValueChanged<BSFPrintElementAlignmentType> onAlignmentChanged;
  final ValueChanged<bool> onDrawLabelBelowBarcodeChanged;
  final ValueChanged<String> onPrefixChanged;
  final ValueChanged<BSFPrintLabelFieldFormatEntity> onFormatChanged;
  final ValueChanged<int> onPositionStartCharacterChanged;
  final ValueChanged<int> onMaxCharacterSizeChanged;
  final ValueChanged<int> onFontTypeChanged;
  final ValueChanged<bool> onFontSizeChange;
  final ValueChanged<bool> onIsBoldChanged;

  const PrintLabelLayoutFieldEditor({
    super.key,
    required this.layoutCode,
    required this.field,
    required this.formats,
    required this.coordinateUnit,
    required this.onCoordinateXChanged,
    required this.onCoordinateYChanged,
    required this.onWidthChanged,
    required this.onHeightChanged,
    required this.onRatioBarCodeChanged,
    required this.onRotationChanged,
    required this.onAlignmentChanged,
    required this.onDrawLabelBelowBarcodeChanged,
    required this.onPrefixChanged,
    required this.onFormatChanged,
    required this.onPositionStartCharacterChanged,
    required this.onMaxCharacterSizeChanged,
    required this.onFontTypeChanged,
    required this.onFontSizeChange,
    required this.onIsBoldChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const fastRepeatInterval = Duration(milliseconds: 25);
    final prefixController = useTextEditingController(text: field.prefix);
    final layout = ref.watch(
      printLabelLayoutDetailsControllerProvider(
        layoutCode,
      ).select((state) => state.value),
    );
    final supportsFontType = layout?.supportsFontType(field) ?? false;
    final supportsFontSize = layout?.supportsFontSize(field) ?? false;
    final supportsBold = layout?.supportsBold(field) ?? false;
    final previewContent = switch ((
      field.fieldType,
      field.format?.dateTimePattern,
    )) {
      (BSFPrintLabelFieldType.dateTime, final String pattern) => DateFormat(
        pattern,
      ).format(DateTime.now()),
      _ => field.previewValue ?? field.field?.content ?? '',
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (field.previewValue?.isNotEmpty == true ||
            field.field?.content.isNotEmpty == true)
          TitleAndSubTitle(
            title: 'Conteúdo'.hardcoded,
            subTitle: previewContent,
          ),

        BaseTextFormField(
          controller: prefixController,
          labelText: 'Prefixo'.hardcoded,
          onChanged: onPrefixChanged,
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
          if (field.isBoxOrLine) ...[
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
        if (_showsRotation) ...[
          gapH8,
          BaseText.title('Rotação'.hardcoded),
          gapH4,
          BaseSegmentedButtons<BSFPrintElementRotationType>(
            items: BSFPrintElementRotationType.values,
            selectedValue: field.rotateType,
            itemLabelBuilder: (item) => item.name,
            onChanged: onRotationChanged,
          ),
        ],
        if (field.isBarcode && !field.isQrCode) ...[
          gapH8,
          BaseSwitch(
            title: 'Imprimir o texto abaixo do código de barras'.hardcoded,
            value: field.drawLabelBelowBarcode,
            onChanged: onDrawLabelBelowBarcodeChanged,
          ),
        ],
        if (field.isTextField) ...[
          gapH8,
          BaseText.title('Alinhamento'.hardcoded),
          gapH4,
          BaseSegmentedButtons<BSFPrintElementAlignmentType>(
            items: BSFPrintElementAlignmentType.values,
            selectedValue: field.alignmentType,
            itemLabelBuilder: (item) => switch (item) {
              .left => 'Esquerda'.hardcoded,
              .middle => 'Centro'.hardcoded,
              .right => 'Direita'.hardcoded,
            },
            onChanged: onAlignmentChanged,
          ),
          gapH8,
          BaseDropDown<BSFPrintLabelFieldFormatEntity>(
            label: 'Formato'.hardcoded,
            selectedItem: field.format,
            showLabelAtTopLeft: true,
            items: _applicableFormats
                .map(
                  (format) => DropdownMenuItem(
                    value: format,
                    child: BaseText(format.name),
                  ),
                )
                .toList(),
            onChanged: onFormatChanged,
          ),
        ],
        if (supportsFontType) ...[
          gapH8,
          PrintLabelLayoutValueAdjuster(
            label: 'Tipo da fonte'.hardcoded,
            value: _fontType.toString(),
            onDecrease: _fontType > 1
                ? () => onFontTypeChanged(_fontType - 1)
                : null,
            onIncrease: _fontType < 6
                ? () => onFontTypeChanged(_fontType + 1)
                : null,
          ),
        ],
        gapH4,
        Wrap(
          alignment: .spaceEvenly,
          runAlignment: .spaceEvenly,
          children: [
            if (supportsFontSize) ...[
              Padding(
                padding: const .only(right: Sizes.p8),
                child: PrintLabelLayoutValueAdjuster(
                  label: 'Tamanho da fonte'.hardcoded,
                  value: field.fontSize.toString(),
                  onDecrease: field.fontSize > 0
                      ? () => onFontSizeChange(false)
                      : null,
                  onIncrease: field.fontSize < 216
                      ? () => onFontSizeChange(true)
                      : null,
                ),
              ),
            ],
            if (_showsTextCharacterOptions) ...[
              Padding(
                padding: const .only(right: Sizes.p8),
                child: PrintLabelLayoutValueAdjuster(
                  label: 'Posição inicial'.hardcoded,
                  value: field.positionStartCharacter.toString(),
                  onDecrease: field.positionStartCharacter > 1
                      ? () => onPositionStartCharacterChanged(-1)
                      : null,
                  onIncrease: () => onPositionStartCharacterChanged(1),
                ),
              ),
              PrintLabelLayoutValueAdjuster(
                label: 'Máximo de caracteres'.hardcoded,
                value: field.maxCharacterSize.toString(),
                onDecrease: field.maxCharacterSize > 0
                    ? () => onMaxCharacterSizeChanged(-1)
                    : null,
                onIncrease: () => onMaxCharacterSizeChanged(1),
              ),
            ],
          ],
        ),
        if (supportsBold) ...[
          gapH8,
          BaseCheckBox(
            name: 'Imprimir texto em negrito'.hardcoded,
            enabled: field.isBold,
            onChanged: (value) {
              if (value != null) onIsBoldChanged(value);
            },
          ),
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
    if (field.isBoxOrLine && field.ratioBarCode > 0) {
      return field.ratioBarCode;
    }
    return field.dimensionType == BSFPrintLabelFieldDimensionType.centimeter
        ? 0.1
        : 1.0;
  }

  bool get _showsRotation => !field.isBoxOrLine;

  bool get _showsTextCharacterOptions => field.usesTextCharacterOptions;

  int get _fontType => field.fontTypeNumber.clamp(1, 6);

  List<BSFPrintLabelFieldFormatEntity> get _applicableFormats => formats
      .where(
        (format) => switch (field.fieldType) {
          BSFPrintLabelFieldType.string => format.stringType,
          BSFPrintLabelFieldType.integer => format.integerType,
          BSFPrintLabelFieldType.float => format.floatType,
          BSFPrintLabelFieldType.dateTime => format.dateTimeType,
          _ => false,
        },
      )
      .toList();

  double get _minHeight => _minWidth;

  double get _minStrokeThickness => 1.0;
}
