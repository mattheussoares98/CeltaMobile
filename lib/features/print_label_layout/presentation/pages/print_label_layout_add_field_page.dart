import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/pages/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PrintLabelLayoutAddFieldPage extends HookConsumerWidget {
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
          DropdownMenu<PrintLabelFieldEditorOptionEntity>(
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
            initialSelection: selectedOption.value,
            enableFilter: true,
            requestFocusOnTap: true,
            menuHeight: MediaQuery.sizeOf(context).height * 0.5,
            expandedInsets: EdgeInsets.zero,
            dropdownMenuEntries: fieldOptions
                .map(
                  (option) => DropdownMenuEntry(
                    value: option,
                    label: option.definition.name,
                  ),
                )
                .toList(),
            onSelected: (value) {
              if (value == null) return;
              selectedOption.value = value;
              draft.value = value.draft.copyWith(
                fontType: _initialFontType(ref, value.draft),
                alignmentType: BSFPrintElementAlignmentType.middle,
              );
            },
          ),
          if (selectedOption.value != null && draft.value != null) ...[
            gapH16,
            Expanded(
              child: SingleChildScrollView(
                child: PrintLabelLayoutFieldEditor(
                  layoutCode: layoutCode,
                  field: draft.value!,
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
                    (field) => field.copyWith(
                      width: _updatedValue(field.width, delta),
                    ),
                  ),
                  onHeightChanged: (delta) => _updateDraft(
                    draft,
                    (field) => field.copyWith(
                      height: _updatedValue(field.height, delta),
                    ),
                  ),
                  onRatioBarCodeChanged: (delta) => _updateDraft(
                    draft,
                    (field) => field.copyWith(
                      ratioBarCode: _updatedValue(field.ratioBarCode, delta),
                    ),
                  ),
                  onRotationChanged: (value) => _updateDraft(
                    draft,
                    (field) => field.copyWith(rotateType: value),
                  ),
                  onAlignmentChanged: (value) => _updateDraft(
                    draft,
                    (field) => field.copyWith(alignmentType: value),
                  ),
                  onDrawLabelBelowBarcodeChanged: (value) => _updateDraft(
                    draft,
                    (field) => field.copyWith(drawLabelBelowBarcode: value),
                  ),
                  onPrefixChanged: (value) => _updateDraft(
                    draft,
                    (field) => field.copyWith(prefix: value),
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
                      fontSize:
                          PrintLabelLayoutDetailsController.changedFontSize(
                            field.fontSize,
                            advance,
                          ),
                    ),
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
          ],
          if (selectedOption.value == null) const Spacer(),
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

  int _updatedIntValue(int value, int delta) =>
      (value + delta).clamp(0, 2147483647);

  String _initialFontType(WidgetRef ref, BSFPrintLabelLayoutFieldEntity field) {
    final layout = ref
        .read(printLabelLayoutDetailsControllerProvider(layoutCode))
        .value;
    if (layout?.supportsFontType(field) != true) return field.fontType;

    const supportedFontTypes = {'1', '2', '3', '4', '5', '6'};
    return supportedFontTypes.contains(field.fontType) ? field.fontType : '1';
  }
}
