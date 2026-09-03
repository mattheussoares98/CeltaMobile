import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/models/models.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/pages/components/editor/editor.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class PrintLabelLayoutFieldEditor extends HookConsumerWidget {
  final int layoutCode;
  final BSFPrintLabelLayoutFieldEntity? field;
  final List<PrintLabelFieldEditorOptionEntity>? fieldOptions;
  final PrintLabelFieldEditorOptionEntity? selectedFieldOption;
  final ValueChanged<PrintLabelFieldEditorOptionEntity> onFieldOptionChanged;
  final List<BSFPrintLabelFieldDefinitionEntity> fieldDefinitions;
  final List<BSFPrintLabelFieldFormatEntity> formats;
  final BSFPrintLabelCoordinateUnit? coordinateUnit;
  final ValueChanged<double> onCoordinateXChanged;
  final ValueChanged<double> onCoordinateYChanged;
  final ValueChanged<double> onWidthChanged;
  final ValueChanged<double> onHeightChanged;
  final ValueChanged<double> onSizeChanged;
  final ValueChanged<double> onRatioBarCodeChanged;
  final ValueChanged<BSFBarcodeSimbologyType> onBarcodeSimbologyTypeChanged;
  final ValueChanged<BSFPrintLabelFieldDefinitionEntity>
  onFieldForDataBarcodeChanged;
  final ValueChanged<BSFPrintElementRotationType> onRotationChanged;
  final ValueChanged<BSFPrintElementAlignmentType> onAlignmentChanged;
  final ValueChanged<int> onQuantityDecimalPlacesChanged;
  final ValueChanged<bool> onDrawLabelBelowBarcodeChanged;
  final ValueChanged<String> onPrefixChanged;
  final ValueChanged<String> onImageNameChanged;
  final ValueChanged<BSFPrintLabelFieldFormatEntity> onFormatChanged;
  final ValueChanged<int> onPositionStartCharacterChanged;
  final ValueChanged<int> onMaxCharacterSizeChanged;
  final ValueChanged<int> onFontTypeChanged;
  final ValueChanged<bool> onFontSizeChange;
  final ValueChanged<bool> onIsBoldChanged;
  final ValueChanged<bool> onIsReverseTextChanged;

  const PrintLabelLayoutFieldEditor({
    super.key,
    required this.layoutCode,
    required this.field,
    required this.fieldOptions,
    required this.selectedFieldOption,
    required this.onFieldOptionChanged,
    required this.fieldDefinitions,
    required this.formats,
    required this.coordinateUnit,
    required this.onCoordinateXChanged,
    required this.onCoordinateYChanged,
    required this.onWidthChanged,
    required this.onHeightChanged,
    required this.onSizeChanged,
    required this.onRatioBarCodeChanged,
    required this.onBarcodeSimbologyTypeChanged,
    required this.onFieldForDataBarcodeChanged,
    required this.onRotationChanged,
    required this.onAlignmentChanged,
    required this.onQuantityDecimalPlacesChanged,
    required this.onDrawLabelBelowBarcodeChanged,
    required this.onPrefixChanged,
    required this.onImageNameChanged,
    required this.onFormatChanged,
    required this.onPositionStartCharacterChanged,
    required this.onMaxCharacterSizeChanged,
    required this.onFontTypeChanged,
    required this.onFontSizeChange,
    required this.onIsBoldChanged,
    required this.onIsReverseTextChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const fastRepeatInterval = Duration(milliseconds: 25);
    const barcodeRatioStep = 0.1;
    final field = this.field;
    final fieldSelector = fieldOptions == null
        ? null
        : DropdownMenu<PrintLabelFieldEditorOptionEntity>(
            key: ValueKey(selectedFieldOption?.definition),
            label: BaseText('Campo'.hardcoded),
            leadingIcon: const PlatformIcon(
              materialIcon: Icons.search,
              cupertinoIcon: CupertinoIcons.search,
            ),
            trailingIcon: const PlatformIcon(
              materialIcon: Icons.keyboard_arrow_down,
              cupertinoIcon: CupertinoIcons.chevron_down,
            ),
            selectedTrailingIcon: const PlatformIcon(
              materialIcon: Icons.keyboard_arrow_up,
              cupertinoIcon: CupertinoIcons.chevron_up,
            ),
            initialSelection: selectedFieldOption,
            enableFilter: true,
            requestFocusOnTap: true,
            menuHeight: MediaQuery.sizeOf(context).height * 0.5,
            expandedInsets: EdgeInsets.zero,
            dropdownMenuEntries: fieldOptions!
                .map(
                  (option) => DropdownMenuEntry(
                    value: option,
                    label: option.definition.name,
                  ),
                )
                .toList(),
            onSelected: (option) {
              if (option == null || option == selectedFieldOption) return;
              onFieldOptionChanged(option);
            },
          );
    if (field == null) return fieldSelector ?? const SizedBox.shrink();

    final prefixController = useTextEditingController(text: field.prefix);
    final imageNameController = useTextEditingController(text: field.imageName);
    final layout = ref.watch(
      printLabelLayoutDetailsControllerProvider(
        layoutCode,
      ).select((state) => state.value),
    );
    final supportsFontType = layout?.supportsFontType(field) ?? false;
    final supportsFontSize = layout?.supportsFontSize(field) ?? false;
    final supportsBold = layout?.supportsBold(field) ?? false;
    final supportsAlignment = layout?.supportsAlignment(field) ?? false;
    final supportsReverseText = layout?.supportsReverseText(field) ?? false;
    final supportsBarcodeRatio = layout?.supportsBarcodeRatio(field) ?? false;
    final supportsGenericBarcodeControls =
        layout?.supportsGenericBarcodeControls(field) ?? false;
    final supportsRotation = layout?.supportsRotation(field) ?? false;
    final supportsQrImageName =
        layout != null && !layout.isGenericPrinter && field.isQrCode;
    final resolvedCoordinateUnit =
        coordinateUnit ?? BSFPrintLabelCoordinateUnit.printerDot;
    final previewContent = switch ((
      field.fieldType,
      field.format?.dateTimePattern,
    )) {
      (BSFPrintLabelFieldType.dateTime, final String pattern) => DateFormat(
        pattern,
      ).format(DateTime.now()),
      _ when layout != null => PrintLabelPreviewMetrics(
        layout,
      ).previewText(field),
      _ => field.previewValue ?? field.field?.content ?? '',
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (fieldSelector != null) ...[fieldSelector, gapH16],
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
        Wrap(
          alignment: .spaceEvenly,
          runAlignment: .spaceEvenly,
          children: [
            PrintLabelLayoutValueAdjuster(
              label: 'Eixo X'.hardcoded,
              repeatInterval:
                  fastRepeatInterval * resolvedCoordinateUnit.editorStep,
              value: resolvedCoordinateUnit.format(field.coordinateX),
              onDecrease: field.coordinateX > 0
                  ? () =>
                        onCoordinateXChanged(-resolvedCoordinateUnit.editorStep)
                  : null,
              onIncrease: () =>
                  onCoordinateXChanged(resolvedCoordinateUnit.editorStep),
            ),
            PrintLabelLayoutValueAdjuster(
              label: 'Eixo Y'.hardcoded,
              repeatInterval:
                  fastRepeatInterval * resolvedCoordinateUnit.editorStep,
              value: resolvedCoordinateUnit.format(field.coordinateY),
              onDecrease: field.coordinateY > 0
                  ? () =>
                        onCoordinateYChanged(-resolvedCoordinateUnit.editorStep)
                  : null,
              onIncrease: () =>
                  onCoordinateYChanged(resolvedCoordinateUnit.editorStep),
            ),
          ],
        ),
        if (field.dimensionType !=
            BSFPrintLabelFieldDimensionType.notApplicable) ...[
          gapH4,
          Wrap(
            alignment: .spaceEvenly,
            runAlignment: .spaceEvenly,
            children: [
              if (field.usesSingleSizeEditor)
                PrintLabelLayoutValueAdjuster(
                  label: 'Tamanho'.hardcoded,
                  repeatInterval:
                      fastRepeatInterval * resolvedCoordinateUnit.editorStep,
                  value: field.dimensionType.format(field.width),
                  onDecrease: field.width > field.minimumEditorWidth
                      ? () => onSizeChanged(-field.dimensionType.editorStep)
                      : null,
                  onIncrease: () =>
                      onSizeChanged(field.dimensionType.editorStep),
                )
              else ...[
                PrintLabelLayoutValueAdjuster(
                  label: 'Largura'.hardcoded,
                  repeatInterval:
                      fastRepeatInterval * resolvedCoordinateUnit.editorStep,
                  value: field.dimensionType.format(field.width),
                  onDecrease: field.width > field.minimumEditorWidth
                      ? () => onWidthChanged(-field.dimensionType.editorStep)
                      : null,
                  onIncrease: () =>
                      onWidthChanged(field.dimensionType.editorStep),
                ),
                PrintLabelLayoutValueAdjuster(
                  label: 'Altura'.hardcoded,
                  repeatInterval:
                      fastRepeatInterval * resolvedCoordinateUnit.editorStep,
                  value: field.dimensionType.format(field.height),
                  onDecrease: field.height > field.minimumEditorHeight
                      ? () => onHeightChanged(-field.dimensionType.editorStep)
                      : null,
                  onIncrease: () =>
                      onHeightChanged(field.dimensionType.editorStep),
                ),
              ],
            ],
          ),
          if (field.isBoxOrLine || supportsBarcodeRatio) ...[
            gapH4,
            PrintLabelLayoutValueAdjuster(
              label:
                  (field.isBoxOrLine
                          ? 'Espessura do traço'
                          : 'Proporção das barras')
                      .hardcoded,
              value: supportsBarcodeRatio
                  ? field.ratioBarCode.toStringAsFixed(1)
                  : field.dimensionType.format(field.ratioBarCode),
              onDecrease:
                  field.ratioBarCode > field.minimumEditorStrokeThickness
                  ? () => onRatioBarCodeChanged(
                      supportsBarcodeRatio
                          ? -barcodeRatioStep
                          : -field.dimensionType.editorStep,
                    )
                  : null,
              onIncrease: () => onRatioBarCodeChanged(
                supportsBarcodeRatio
                    ? barcodeRatioStep
                    : field.dimensionType.editorStep,
              ),
            ),
          ],
        ],
        if (supportsRotation) ...[
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
        if (supportsQrImageName) ...[
          gapH8,
          BaseTextFormField(
            controller: imageNameController,
            labelText: 'Nome da imagem'.hardcoded,
            onChanged: onImageNameChanged,
          ),
        ],
        if (supportsGenericBarcodeControls) ...[
          gapH8,
          BaseDropDown<BSFBarcodeSimbologyType>(
            label: 'Tipo do código de barras'.hardcoded,
            selectedItem: field.barcodeSimbologyType,
            showLabelAtTopLeft: true,
            items: BSFBarcodeSimbologyType.values
                .map(
                  (type) => DropdownMenuItem(
                    value: type,
                    child: BaseText(type.apiValue.hardcoded),
                  ),
                )
                .toList(),
            onChanged: onBarcodeSimbologyTypeChanged,
          ),
          gapH8,
          BaseDropDown<BSFPrintLabelFieldDefinitionEntity>(
            label: 'Campo representante do dado'.hardcoded,
            selectedItem: field.fieldForDataBarcode,
            showLabelAtTopLeft: true,
            items: fieldDefinitions
                .map(
                  (definition) => DropdownMenuItem(
                    value: definition,
                    child: BaseText(definition.name),
                  ),
                )
                .toList(),
            onChanged: onFieldForDataBarcodeChanged,
          ),
        ],
        if (field.isBarcode) ...[
          gapH8,
          BaseSwitch(
            title: 'Imprimir o texto abaixo do código de barras'.hardcoded,
            value: field.drawLabelBelowBarcode,
            onChanged: onDrawLabelBelowBarcodeChanged,
          ),
        ],
        if (supportsAlignment) ...[
          gapH8,
          BaseText.title('Alinhamento'.hardcoded),
          gapH4,
          BaseSegmentedButtons<BSFPrintElementAlignmentType>(
            items: BSFPrintElementAlignmentType.values,
            selectedValue: field.alignmentType,
            itemLabelBuilder: (item) => item.label.hardcoded,
            onChanged: onAlignmentChanged,
          ),
        ],
        if (field.isTextField) ...[
          gapH8,
          BaseDropDown<BSFPrintLabelFieldFormatEntity>(
            label: 'Formato'.hardcoded,
            selectedItem: field.format,
            showLabelAtTopLeft: true,
            items: field
                .applicableFormats(formats)
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

        gapH4,
        Wrap(
          alignment: .spaceEvenly,
          runAlignment: .spaceEvenly,
          children: [
            if (field.supportsDecimalPlaces) ...[
              Padding(
                padding: const .only(right: Sizes.p8),
                child: PrintLabelLayoutValueAdjuster(
                  label: 'Casas decimais'.hardcoded,
                  value: field.quantityDecimalPlaces.toString(),
                  onDecrease: field.quantityDecimalPlaces > 0
                      ? () => onQuantityDecimalPlacesChanged(-1)
                      : null,
                  onIncrease: field.quantityDecimalPlaces < 9999
                      ? () => onQuantityDecimalPlacesChanged(1)
                      : null,
                ),
              ),
            ],
            if (supportsFontType) ...[
              Padding(
                padding: const .only(right: Sizes.p8),
                child: PrintLabelLayoutValueAdjuster(
                  label: 'Tipo da fonte'.hardcoded,
                  value: field.editorFontType.toString(),
                  onDecrease: field.editorFontType > 1
                      ? () => onFontTypeChanged(field.editorFontType - 1)
                      : null,
                  onIncrease: field.editorFontType < 6
                      ? () => onFontTypeChanged(field.editorFontType + 1)
                      : null,
                ),
              ),
            ],
            if (supportsFontSize)
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

            if (field.usesTextCharacterOptions) ...[
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
        if (supportsReverseText) ...[
          gapH8,
          BaseCheckBox(
            name: 'Imprimir texto reverso'.hardcoded,
            enabled: field.isReverseText,
            onChanged: (value) {
              if (value != null) onIsReverseTextChanged(value);
            },
          ),
        ],
      ],
    );
  }
}
