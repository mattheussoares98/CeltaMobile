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
  final ValueChanged<BSFPrintLabelLayoutFieldEntity> onFieldChanged;

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
    required this.onFieldChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const fastRepeatInterval = Duration(milliseconds: 1);
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
    final supportsDrawLabelBelowBarcode =
        layout?.supportsDrawLabelBelowBarcode(field) ?? false;
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
          onChanged: (value) => onFieldChanged(_withPrefix(field, value)),
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
                  ? () => onFieldChanged(
                      field.copyWith(
                        coordinateX: _updatedValue(
                          field.coordinateX,
                          -resolvedCoordinateUnit.editorStep,
                        ),
                      ),
                    )
                  : null,
              onIncrease: () => onFieldChanged(
                field.copyWith(
                  coordinateX: _updatedValue(
                    field.coordinateX,
                    resolvedCoordinateUnit.editorStep,
                  ),
                ),
              ),
            ),
            PrintLabelLayoutValueAdjuster(
              label: 'Eixo Y'.hardcoded,
              repeatInterval:
                  fastRepeatInterval * resolvedCoordinateUnit.editorStep,
              value: resolvedCoordinateUnit.format(field.coordinateY),
              onDecrease: field.coordinateY > 0
                  ? () => onFieldChanged(
                      field.copyWith(
                        coordinateY: _updatedValue(
                          field.coordinateY,
                          -resolvedCoordinateUnit.editorStep,
                        ),
                      ),
                    )
                  : null,
              onIncrease: () => onFieldChanged(
                field.copyWith(
                  coordinateY: _updatedValue(
                    field.coordinateY,
                    resolvedCoordinateUnit.editorStep,
                  ),
                ),
              ),
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
                      ? () {
                          final size = _updatedValue(
                            field.width,
                            -field.dimensionType.editorStep,
                          );
                          onFieldChanged(
                            field.copyWith(width: size, height: size),
                          );
                        }
                      : null,
                  onIncrease: () {
                    final size = _updatedValue(
                      field.width,
                      field.dimensionType.editorStep,
                    );
                    onFieldChanged(field.copyWith(width: size, height: size));
                  },
                )
              else ...[
                PrintLabelLayoutValueAdjuster(
                  label: 'Largura'.hardcoded,
                  repeatInterval:
                      fastRepeatInterval * resolvedCoordinateUnit.editorStep,
                  value: field.dimensionType.format(field.width),
                  onDecrease: field.width > field.minimumEditorWidth
                      ? () => onFieldChanged(
                          field.copyWith(
                            width: _updatedValue(
                              field.width,
                              -field.dimensionType.editorStep,
                            ),
                          ),
                        )
                      : null,
                  onIncrease: () => onFieldChanged(
                    field.copyWith(
                      width: _updatedValue(
                        field.width,
                        field.dimensionType.editorStep,
                      ),
                    ),
                  ),
                ),
                PrintLabelLayoutValueAdjuster(
                  label: 'Altura'.hardcoded,
                  repeatInterval:
                      fastRepeatInterval * resolvedCoordinateUnit.editorStep,
                  value: field.dimensionType.format(field.height),
                  onDecrease: field.height > field.minimumEditorHeight
                      ? () => onFieldChanged(
                          field.copyWith(
                            height: _updatedValue(
                              field.height,
                              -field.dimensionType.editorStep,
                            ),
                          ),
                        )
                      : null,
                  onIncrease: () => onFieldChanged(
                    field.copyWith(
                      height: _updatedValue(
                        field.height,
                        field.dimensionType.editorStep,
                      ),
                    ),
                  ),
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
                  ? () => onFieldChanged(
                      field.copyWith(
                        ratioBarCode: _updatedValue(
                          field.ratioBarCode,
                          supportsBarcodeRatio
                              ? -barcodeRatioStep
                              : -field.dimensionType.editorStep,
                        ),
                      ),
                    )
                  : null,
              onIncrease: () => onFieldChanged(
                field.copyWith(
                  ratioBarCode: _updatedValue(
                    field.ratioBarCode,
                    supportsBarcodeRatio
                        ? barcodeRatioStep
                        : field.dimensionType.editorStep,
                  ),
                ),
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
            onChanged: (value) =>
                onFieldChanged(field.copyWith(rotateType: value)),
          ),
        ],
        if (supportsQrImageName) ...[
          gapH8,
          BaseTextFormField(
            controller: imageNameController,
            labelText: 'Nome da imagem'.hardcoded,
            onChanged: (value) =>
                onFieldChanged(field.copyWith(imageName: value)),
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
            onChanged: (value) =>
                onFieldChanged(field.copyWith(barcodeSimbologyType: value)),
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
            onChanged: (value) =>
                onFieldChanged(field.copyWith(fieldForDataBarcode: value)),
          ),
        ],
        if (supportsDrawLabelBelowBarcode) ...[
          gapH8,
          BaseSwitch(
            title: 'Imprimir o texto abaixo do código de barras'.hardcoded,
            value: field.drawLabelBelowBarcode,
            onChanged: (value) =>
                onFieldChanged(field.copyWith(drawLabelBelowBarcode: value)),
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
            onChanged: (value) =>
                onFieldChanged(field.copyWith(alignmentType: value)),
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
            onChanged: (value) => onFieldChanged(field.copyWith(format: value)),
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
                      ? () => onFieldChanged(
                          field.copyWith(
                            quantityDecimalPlaces: _updatedIntValue(
                              field.quantityDecimalPlaces,
                              -1,
                              maximum: 9999,
                            ),
                          ),
                        )
                      : null,
                  onIncrease: field.quantityDecimalPlaces < 9999
                      ? () => onFieldChanged(
                          field.copyWith(
                            quantityDecimalPlaces: _updatedIntValue(
                              field.quantityDecimalPlaces,
                              1,
                              maximum: 9999,
                            ),
                          ),
                        )
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
                      ? () => onFieldChanged(
                          field.copyWith(
                            fontType: (field.editorFontType - 1).toString(),
                          ),
                        )
                      : null,
                  onIncrease: field.editorFontType < 6
                      ? () => onFieldChanged(
                          field.copyWith(
                            fontType: (field.editorFontType + 1).toString(),
                          ),
                        )
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
                      ? () => onFieldChanged(
                          field.copyWith(
                            fontSize:
                                PrintLabelLayoutDetailsController.changedFontSize(
                                  field.fontSize,
                                  false,
                                ),
                          ),
                        )
                      : null,
                  onIncrease: field.fontSize < 216
                      ? () => onFieldChanged(
                          field.copyWith(
                            fontSize:
                                PrintLabelLayoutDetailsController.changedFontSize(
                                  field.fontSize,
                                  true,
                                ),
                          ),
                        )
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
                      ? () => onFieldChanged(
                          field.copyWith(
                            positionStartCharacter: _updatedIntValue(
                              field.positionStartCharacter,
                              -1,
                            ),
                          ),
                        )
                      : null,
                  onIncrease: () => onFieldChanged(
                    field.copyWith(
                      positionStartCharacter: _updatedIntValue(
                        field.positionStartCharacter,
                        1,
                      ),
                    ),
                  ),
                ),
              ),
              PrintLabelLayoutValueAdjuster(
                label: 'Máximo de caracteres'.hardcoded,
                value: field.maxCharacterSize.toString(),
                onDecrease: field.maxCharacterSize > 0
                    ? () => onFieldChanged(
                        field.copyWith(
                          maxCharacterSize: _updatedIntValue(
                            field.maxCharacterSize,
                            -1,
                          ),
                        ),
                      )
                    : null,
                onIncrease: () => onFieldChanged(
                  field.copyWith(
                    maxCharacterSize: _updatedIntValue(
                      field.maxCharacterSize,
                      1,
                    ),
                  ),
                ),
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
              if (value != null) {
                onFieldChanged(field.copyWith(isBold: value));
              }
            },
          ),
        ],
        if (supportsReverseText) ...[
          gapH8,
          BaseCheckBox(
            name: 'Imprimir texto reverso'.hardcoded,
            enabled: field.isReverseText,
            onChanged: (value) {
              if (value != null) {
                onFieldChanged(field.copyWith(isReverseText: value));
              }
            },
          ),
        ],
      ],
    );
  }

  double _updatedValue(double value, double delta) {
    final updatedValue = (value + delta).clamp(0.0, double.infinity);
    return (updatedValue * 100).roundToDouble() / 100;
  }

  int _updatedIntValue(int value, int delta, {int maximum = 2147483647}) =>
      (value + delta).clamp(0, maximum);

  BSFPrintLabelLayoutFieldEntity _withPrefix(
    BSFPrintLabelLayoutFieldEntity field,
    String prefix,
  ) {
    final previewValue = field.previewValue;
    if (previewValue == null) return field.copyWith(prefix: prefix);

    final valueWithoutPrefix =
        field.field?.fieldType == BSFPrintLabelFieldType.string
        ? ""
        : field.prefix.isNotEmpty && previewValue.startsWith(field.prefix)
        ? previewValue.substring(field.prefix.length)
        : previewValue;

    return field.copyWith(
      prefix: prefix,
      previewValue: '$prefix$valueWithoutPrefix',
    );
  }
}
