import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/pages/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PrintLabelLayoutFieldItem extends ConsumerWidget {
  final int layoutCode;
  final int fieldIndex;
  final BSFPrintLabelLayoutFieldEntity field;
  final BSFPrintLabelCoordinateUnit? coordinateUnit;
  final bool showVisibilityButton;

  const PrintLabelLayoutFieldItem({
    super.key,
    required this.layoutCode,
    required this.fieldIndex,
    required this.field,
    required this.coordinateUnit,
    this.showVisibilityButton = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(
      printLabelLayoutDetailsControllerProvider(layoutCode).notifier,
    );
    final options = ref.watch(
      printLabelFieldEditorOptionsControllerProvider(
        layoutCode,
      ).select((s) => s.value),
    );
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: TitleAndSubTitle(
                    title: 'Campo'.hardcoded,
                    subTitle: field.field?.name,
                    emptyMessage: 'Não informado'.hardcoded,
                  ),
                ),
                if (showVisibilityButton)
                  IconButton(
                    onPressed: () =>
                        controller.toggleFieldVisibility(fieldIndex),
                    tooltip: field.isVisible
                        ? 'Ocultar do preview'.hardcoded
                        : 'Exibir no preview'.hardcoded,
                    icon: PlatformIcon(
                      cupertinoIcon: field.isVisible
                          ? CupertinoIcons.eye
                          : CupertinoIcons.eye_slash,
                      materialIcon: field.isVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
              ],
            ),
            PrintLabelLayoutFieldEditor(
              layoutCode: layoutCode,
              field: field,
              fieldDefinitions:
                  options?.fieldOptions
                      .map((option) => option.definition)
                      .toList() ??
                  [?field.fieldForDataBarcode],
              formats:
                  options?.formats ?? [if (field.format != null) field.format!],
              coordinateUnit: coordinateUnit,
              onCoordinateXChanged: (delta) =>
                  controller.updateFieldCoordinateX(fieldIndex, delta),
              onCoordinateYChanged: (delta) =>
                  controller.updateFieldCoordinateY(fieldIndex, delta),
              onWidthChanged: (delta) =>
                  controller.updateFieldWidth(fieldIndex, delta),
              onHeightChanged: (delta) =>
                  controller.updateFieldHeight(fieldIndex, delta),
              onSizeChanged: (delta) =>
                  controller.updateFieldSize(fieldIndex, delta),
              onRatioBarCodeChanged: (delta) =>
                  controller.updateFieldRatioBarCode(fieldIndex, delta),
              onBarcodeSimbologyTypeChanged: (value) =>
                  controller.updateFieldBarcodeSimbologyType(fieldIndex, value),
              onFieldForDataBarcodeChanged: (value) =>
                  controller.updateFieldForDataBarcode(fieldIndex, value),
              onRotationChanged: (value) =>
                  controller.updateFieldRotateType(fieldIndex, value),
              onAlignmentChanged: (value) =>
                  controller.updateFieldAlignmentType(fieldIndex, value),
              onQuantityDecimalPlacesChanged: (delta) => controller
                  .updateFieldQuantityDecimalPlaces(fieldIndex, delta),
              onDrawLabelBelowBarcodeChanged: (value) => controller
                  .updateFieldDrawLabelBelowBarcode(fieldIndex, value),
              onPrefixChanged: (value) =>
                  controller.updateFieldPrefix(fieldIndex, value),
              onImageNameChanged: (value) =>
                  controller.updateFieldImageName(fieldIndex, value),
              onFormatChanged: (value) =>
                  controller.updateFieldFormat(fieldIndex, value),
              onFontTypeChanged: (value) =>
                  controller.updateFieldFontType(fieldIndex, value),
              onFontSizeChange: (advance) =>
                  controller.changeFieldFontSize(fieldIndex, advance),
              onIsBoldChanged: (value) =>
                  controller.updateFieldIsBold(fieldIndex, value),
              onIsReverseTextChanged: (value) =>
                  controller.updateFieldIsReverseText(fieldIndex, value),
              onPositionStartCharacterChanged: (delta) => controller
                  .updateFieldPositionStartCharacter(fieldIndex, delta),
              onMaxCharacterSizeChanged: (delta) =>
                  controller.updateFieldMaxCharacterSize(fieldIndex, delta),
            ),
          ],
        ),
      ),
    );
  }
}
