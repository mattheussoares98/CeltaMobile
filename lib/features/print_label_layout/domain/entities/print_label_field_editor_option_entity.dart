import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class PrintLabelFieldEditorOptionEntity extends Equatable {
  final BSFPrintLabelFieldDefinitionEntity definition;
  final BSFPrintLabelLayoutFieldEntity draft;

  const PrintLabelFieldEditorOptionEntity({
    required this.definition,
    required this.draft,
  });

  @override
  List<Object?> get props => [definition, draft];
}
