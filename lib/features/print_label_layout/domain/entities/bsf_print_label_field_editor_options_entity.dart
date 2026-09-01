import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class BSFPrintLabelFieldEditorOptionsEntity extends Equatable {
  final List<PrintLabelFieldEditorOptionEntity> fieldOptions;
  final List<BSFPrintLabelFieldFormatEntity> formats;

  const BSFPrintLabelFieldEditorOptionsEntity({
    required this.fieldOptions,
    required this.formats,
  });

  @override
  List<Object?> get props => [fieldOptions, formats];
}
