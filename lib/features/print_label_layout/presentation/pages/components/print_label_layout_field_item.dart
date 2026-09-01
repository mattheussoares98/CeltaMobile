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
  final BSFPrintLabelLayoutFieldEntity field;
  final BSFPrintLabelCoordinateUnit? coordinateUnit;

  const PrintLabelLayoutFieldItem({
    super.key,
    required this.layoutCode,
    required this.field,
    required this.coordinateUnit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(
      printLabelLayoutDetailsControllerProvider(layoutCode).notifier,
    );
    final coordStep = _coordinateStep;
    final dimStep = _dimensionStep;

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
                IconButton(
                  onPressed: () => controller.toggleFieldVisibility(field.code),
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
            if (field.field?.content.isNotEmpty == true)
              TitleAndSubTitle(
                title: 'Conteúdo'.hardcoded,
                subTitle: field.field!.content,
              ),
            gapH4,
            BaseText.title('Coordenadas ($_coordinateUnit)'.hardcoded),
            gapH4,
            Row(
              children: [
                Expanded(
                  child: PrintLabelLayoutValueAdjuster(
                    label: 'X'.hardcoded,
                    value: _formatCoordinate(field.coordinateX),
                    onDecrease: field.coordinateX > 0
                        ? () => controller.updateFieldCoordinateX(
                            field.code,
                            -coordStep,
                          )
                        : null,
                    onIncrease: () => controller.updateFieldCoordinateX(
                      field.code,
                      coordStep,
                    ),
                  ),
                ),
                Expanded(
                  child: PrintLabelLayoutValueAdjuster(
                    label: 'Y'.hardcoded,
                    value: _formatCoordinate(field.coordinateY),
                    onDecrease: field.coordinateY > 0
                        ? () => controller.updateFieldCoordinateY(
                            field.code,
                            -coordStep,
                          )
                        : null,
                    onIncrease: () => controller.updateFieldCoordinateY(
                      field.code,
                      coordStep,
                    ),
                  ),
                ),
              ],
            ),
            if (field.dimensionType !=
                BSFPrintLabelFieldDimensionType.notApplicable) ...[
              gapH8,
              BaseText.title('Dimensões ($_dimensionDescription)'.hardcoded),
              gapH4,
              Row(
                children: [
                  Expanded(
                    child: PrintLabelLayoutValueAdjuster(
                      label: 'Largura'.hardcoded,
                      value: _formatDimension(field.width),
                      onDecrease: field.width > 0
                          ? () => controller.updateFieldWidth(
                              field.code,
                              -dimStep,
                            )
                          : null,
                      onIncrease: () =>
                          controller.updateFieldWidth(field.code, dimStep),
                    ),
                  ),
                  Expanded(
                    child: PrintLabelLayoutValueAdjuster(
                      label: 'Altura'.hardcoded,
                      value: _formatDimension(field.height),
                      onDecrease: field.height > 0
                          ? () => controller.updateFieldHeight(
                              field.code,
                              -dimStep,
                            )
                          : null,
                      onIncrease: () =>
                          controller.updateFieldHeight(field.code, dimStep),
                    ),
                  ),
                ],
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
              TitleAndSubTitle(
                title: 'Prefixo'.hardcoded,
                subTitle: field.prefix,
              ),
            ],
          ],
        ),
      ),
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
}
