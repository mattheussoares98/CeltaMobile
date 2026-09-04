import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/models/models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'print_label_layout_add_field_controller.g.dart';

@riverpod
class PrintLabelLayoutAddFieldController
    extends _$PrintLabelLayoutAddFieldController {
  static const _defaultFloatDecimalPlaces = 2;

  @override
  PrintLabelLayoutAddFieldState build(int layoutCode) =>
      const PrintLabelLayoutAddFieldState();

  void selectFieldOption(PrintLabelFieldEditorOptionEntity option) {
    final initialDraft = _withMinimumDimensions(option.draft);
    state = PrintLabelLayoutAddFieldState(
      selectedOption: option,
      draft: initialDraft.copyWith(
        fontType: _initialFontType(initialDraft),
        alignmentType: BSFPrintElementAlignmentType.middle,
        quantityDecimalPlaces: initialDraft.supportsDecimalPlaces
            ? _defaultFloatDecimalPlaces
            : initialDraft.quantityDecimalPlaces,
      ),
    );
  }

  void updateField(BSFPrintLabelLayoutFieldEntity field) {
    state = state.copyWith(draft: field);
  }

  void addField() {
    final draft = state.draft;
    if (draft == null) return;
    ref
        .read(printLabelLayoutDetailsControllerProvider(layoutCode).notifier)
        .addField(draft);
  }

  String _initialFontType(BSFPrintLabelLayoutFieldEntity field) {
    final layout = ref
        .read(printLabelLayoutDetailsControllerProvider(layoutCode))
        .value;
    if (layout?.supportsFontType(field) != true) return field.fontType;

    const supportedFontTypes = {'1', '2', '3', '4', '5', '6'};
    return supportedFontTypes.contains(field.fontType) ? field.fontType : '1';
  }

  BSFPrintLabelLayoutFieldEntity _withMinimumDimensions(
    BSFPrintLabelLayoutFieldEntity field,
  ) {
    if (field.dimensionType == BSFPrintLabelFieldDimensionType.notApplicable) {
      return field;
    }

    return field.copyWith(
      width: field.width.clamp(field.minimumEditorWidth, double.infinity),
      height: field.height.clamp(field.minimumEditorHeight, double.infinity),
    );
  }
}
