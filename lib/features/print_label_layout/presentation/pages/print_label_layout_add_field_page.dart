import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/pages/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PrintLabelLayoutAddFieldPage extends HookConsumerWidget {
  static const _defaultFloatDecimalPlaces = 2;

  final int layoutCode;
  final List<PrintLabelFieldEditorOptionEntity> fieldOptions;
  final List<BSFPrintLabelFieldFormatEntity> formats;

  const PrintLabelLayoutAddFieldPage({
    super.key,
    required this.layoutCode,
    required this.fieldOptions,
    required this.formats,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedOption = useState<PrintLabelFieldEditorOptionEntity?>(null);
    final draft = useState<BSFPrintLabelLayoutFieldEntity?>(null);
    final coordinateUnit = ref.watch(
      printLabelLayoutDetailsControllerProvider(
        layoutCode,
      ).select((s) => s.value?.coordinateUnit),
    );

    return Padding(
      padding: const EdgeInsets.all(Sizes.p16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BaseText.title('Adicionar campo ao leiaute'.hardcoded),
          gapH16,
          Expanded(
            child: SingleChildScrollView(
              child: PrintLabelLayoutFieldEditor(
                layoutCode: layoutCode,
                field: draft.value,
                fieldOptions: fieldOptions,
                selectedFieldOption: selectedOption.value,
                onFieldOptionChanged: (value) {
                  selectedOption.value = value;
                  draft.value = value.draft.copyWith(
                    fontType: _initialFontType(ref, value.draft),
                    alignmentType: BSFPrintElementAlignmentType.middle,
                    quantityDecimalPlaces: value.draft.supportsDecimalPlaces
                        ? _defaultFloatDecimalPlaces
                        : value.draft.quantityDecimalPlaces,
                  );
                },
                fieldDefinitions: fieldOptions
                    .map((option) => option.definition)
                    .toList(),
                formats: formats,
                coordinateUnit: coordinateUnit,
                onCoordinateXChanged: (delta) => _updateDraft(
                  draft,
                  (field) => field.copyWith(
                    coordinateX: _updatedValue(field.coordinateX, delta),
                  ),
                ),
                onCoordinateYChanged: (delta) => _updateDraft(
                  draft,
                  (field) => field.copyWith(
                    coordinateY: _updatedValue(field.coordinateY, delta),
                  ),
                ),
                onWidthChanged: (delta) => _updateDraft(
                  draft,
                  (field) =>
                      field.copyWith(width: _updatedValue(field.width, delta)),
                ),
                onHeightChanged: (delta) => _updateDraft(
                  draft,
                  (field) => field.copyWith(
                    height: _updatedValue(field.height, delta),
                  ),
                ),
                onSizeChanged: (delta) => _updateDraft(draft, (field) {
                  final size = _updatedValue(field.width, delta);
                  return field.copyWith(width: size, height: size);
                }),
                onRatioBarCodeChanged: (delta) => _updateDraft(
                  draft,
                  (field) => field.copyWith(
                    ratioBarCode: _updatedValue(field.ratioBarCode, delta),
                  ),
                ),
                onBarcodeSimbologyTypeChanged: (value) => _updateDraft(
                  draft,
                  (field) => field.copyWith(barcodeSimbologyType: value),
                ),
                onFieldForDataBarcodeChanged: (value) => _updateDraft(
                  draft,
                  (field) => field.copyWith(fieldForDataBarcode: value),
                ),
                onRotationChanged: (value) => _updateDraft(
                  draft,
                  (field) => field.copyWith(rotateType: value),
                ),
                onAlignmentChanged: (value) => _updateDraft(
                  draft,
                  (field) => field.copyWith(alignmentType: value),
                ),
                onQuantityDecimalPlacesChanged: (delta) => _updateDraft(
                  draft,
                  (field) => field.copyWith(
                    quantityDecimalPlaces: _updatedIntValue(
                      field.quantityDecimalPlaces,
                      delta,
                      maximum: 9999,
                    ),
                  ),
                ),
                onDrawLabelBelowBarcodeChanged: (value) => _updateDraft(
                  draft,
                  (field) => field.copyWith(drawLabelBelowBarcode: value),
                ),
                onPrefixChanged: (value) => _updateDraft(
                  draft,
                  (field) => field.copyWith(prefix: value),
                ),
                onImageNameChanged: (value) => _updateDraft(
                  draft,
                  (field) => field.copyWith(imageName: value),
                ),
                onFormatChanged: (value) => _updateDraft(
                  draft,
                  (field) => field.copyWith(format: value),
                ),
                onFontTypeChanged: (value) => _updateDraft(
                  draft,
                  (field) => field.copyWith(fontType: value.toString()),
                ),
                onFontSizeChange: (advance) => _updateDraft(
                  draft,
                  (field) => field.copyWith(
                    fontSize: PrintLabelLayoutDetailsController.changedFontSize(
                      field.fontSize,
                      advance,
                    ),
                  ),
                ),
                onIsBoldChanged: (value) => _updateDraft(
                  draft,
                  (field) => field.copyWith(isBold: value),
                ),
                onIsReverseTextChanged: (value) => _updateDraft(
                  draft,
                  (field) => field.copyWith(isReverseText: value),
                ),
                onPositionStartCharacterChanged: (delta) => _updateDraft(
                  draft,
                  (field) => field.copyWith(
                    positionStartCharacter: _updatedIntValue(
                      field.positionStartCharacter,
                      delta,
                    ),
                  ),
                ),
                onMaxCharacterSizeChanged: (delta) => _updateDraft(
                  draft,
                  (field) => field.copyWith(
                    maxCharacterSize: _updatedIntValue(
                      field.maxCharacterSize,
                      delta,
                    ),
                  ),
                ),
              ),
            ),
          ),
          PrimaryButton(
            text: 'Adicionar'.hardcoded,
            onPressed: draft.value == null
                ? null
                : () => _addField(context, ref, draft.value!),
          ),
        ],
      ),
    );
  }

  void _addField(
    BuildContext context,
    WidgetRef ref,
    BSFPrintLabelLayoutFieldEntity draft,
  ) {
    ref
        .read(printLabelLayoutDetailsControllerProvider(layoutCode).notifier)
        .addField(draft);
    context.pop();
  }

  void _updateDraft(
    ValueNotifier<BSFPrintLabelLayoutFieldEntity?> draft,
    BSFPrintLabelLayoutFieldEntity Function(
      BSFPrintLabelLayoutFieldEntity field,
    )
    updater,
  ) {
    final currentDraft = draft.value;
    if (currentDraft == null) return;

    draft.value = updater(currentDraft);
  }

  double _updatedValue(double value, double delta) {
    final updatedValue = (value + delta).clamp(0.0, double.infinity);
    return (updatedValue * 100).roundToDouble() / 100;
  }

  int _updatedIntValue(int value, int delta, {int maximum = 2147483647}) =>
      (value + delta).clamp(0, maximum);

  String _initialFontType(WidgetRef ref, BSFPrintLabelLayoutFieldEntity field) {
    final layout = ref
        .read(printLabelLayoutDetailsControllerProvider(layoutCode))
        .value;
    if (layout?.supportsFontType(field) != true) return field.fontType;

    const supportedFontTypes = {'1', '2', '3', '4', '5', '6'};
    return supportedFontTypes.contains(field.fontType) ? field.fontType : '1';
  }
}
