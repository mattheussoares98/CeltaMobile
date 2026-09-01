import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/pages/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PrintLabelLayoutAddFieldPage extends ConsumerStatefulWidget {
  final int layoutCode;
  final List<PrintLabelFieldEditorOptionEntity> fieldOptions;

  const PrintLabelLayoutAddFieldPage({
    super.key,
    required this.layoutCode,
    required this.fieldOptions,
  });

  @override
  ConsumerState<PrintLabelLayoutAddFieldPage> createState() =>
      _PrintLabelLayoutAddFieldPageState();
}

class _PrintLabelLayoutAddFieldPageState
    extends ConsumerState<PrintLabelLayoutAddFieldPage> {
  PrintLabelFieldEditorOptionEntity? selectedOption;

  @override
  Widget build(BuildContext context) {
    final coordinateUnit = ref.watch(
      printLabelLayoutDetailsControllerProvider(
        widget.layoutCode,
      ).select((value) => value.value?.labelPrinter?.coordinateUnit),
    );

    return Padding(
      padding: const EdgeInsets.all(Sizes.p16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BaseText.title('Adicionar campo ao leiaute'.hardcoded),
          gapH16,
          BaseDropDown<PrintLabelFieldEditorOptionEntity>(
            label: 'Campo'.hardcoded,
            selectedItem: selectedOption,
            items: widget.fieldOptions
                .map(
                  (option) => DropdownMenuItem(
                    value: option,
                    child: BaseText(option.definition.name),
                  ),
                )
                .toList(),
            onChanged: (value) => setState(() => selectedOption = value),
          ),
          if (selectedOption != null) ...[
            gapH16,
            TitleAndSubTitle(
              title: 'Tipo'.hardcoded,
              subTitle: selectedOption!.definition.fieldType.name,
            ),
            gapH16,
            Expanded(
              child: SingleChildScrollView(
                child: PrintLabelLayoutFieldEditor(
                  field: selectedOption!.draft,
                  coordinateUnit: coordinateUnit,
                  onCoordinateXChanged: (delta) => _updateDraft(
                    (field) => field.copyWith(
                      coordinateX: _updatedValue(field.coordinateX, delta),
                    ),
                  ),
                  onCoordinateYChanged: (delta) => _updateDraft(
                    (field) => field.copyWith(
                      coordinateY: _updatedValue(field.coordinateY, delta),
                    ),
                  ),
                  onWidthChanged: (delta) => _updateDraft(
                    (field) => field.copyWith(
                      width: _updatedValue(field.width, delta),
                    ),
                  ),
                  onHeightChanged: (delta) => _updateDraft(
                    (field) => field.copyWith(
                      height: _updatedValue(field.height, delta),
                    ),
                  ),
                  onRatioBarCodeChanged: (delta) => _updateDraft(
                    (field) => field.copyWith(
                      ratioBarCode: _updatedValue(field.ratioBarCode, delta),
                    ),
                  ),
                  onRotationChanged: (value) => _updateDraft(
                    (field) => field.copyWith(rotateType: value),
                  ),
                  onDrawLabelBelowBarcodeChanged: (value) => _updateDraft(
                    (field) => field.copyWith(drawLabelBelowBarcode: value),
                  ),
                ),
              ),
            ),
          ],
          if (selectedOption == null) const Spacer(),
          PrimaryButton(
            text: 'Adicionar'.hardcoded,
            onPressed: selectedOption == null ? null : _addField,
          ),
        ],
      ),
    );
  }

  void _addField() {
    ref
        .read(
          printLabelLayoutDetailsControllerProvider(widget.layoutCode).notifier,
        )
        .addField(selectedOption!.draft);
    context.pop();
  }

  void _updateDraft(
    BSFPrintLabelLayoutFieldEntity Function(
      BSFPrintLabelLayoutFieldEntity field,
    )
    updater,
  ) {
    final option = selectedOption;
    if (option == null) return;

    setState(() {
      selectedOption = PrintLabelFieldEditorOptionEntity(
        definition: option.definition,
        draft: updater(option.draft),
      );
    });
  }

  double _updatedValue(double value, double delta) {
    final updatedValue = (value + delta).clamp(0.0, double.infinity);
    return (updatedValue * 100).roundToDouble() / 100;
  }
}
