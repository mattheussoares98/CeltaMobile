import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';

class PrintLabelLayoutAddFieldState {
  final PrintLabelFieldEditorOptionEntity? selectedOption;
  final BSFPrintLabelLayoutFieldEntity? draft;

  const PrintLabelLayoutAddFieldState({this.selectedOption, this.draft});

  PrintLabelLayoutAddFieldState copyWith({
    PrintLabelFieldEditorOptionEntity? selectedOption,
    BSFPrintLabelLayoutFieldEntity? draft,
  }) => PrintLabelLayoutAddFieldState(
    selectedOption: selectedOption ?? this.selectedOption,
    draft: draft ?? this.draft,
  );
}
