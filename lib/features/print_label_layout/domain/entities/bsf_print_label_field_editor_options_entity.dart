import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class BSFPrintLabelFieldEditorOptionsEntity extends Equatable {
  final List<BSFPrintLabelFieldDefinitionEntity> fields;
  final List<BSFPrintLabelLayoutFieldEntity> fieldDrafts;
  final List<BSFPrintLabelFieldFormatEntity> formats;

  const BSFPrintLabelFieldEditorOptionsEntity({
    required this.fields,
    required this.fieldDrafts,
    required this.formats,
  });

  @override
  List<Object?> get props => [fields, fieldDrafts, formats];
}
