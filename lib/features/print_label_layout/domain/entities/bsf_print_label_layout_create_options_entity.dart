import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class BSFPrintLabelLayoutCreateOptionsEntity extends Equatable {
  final BSFPrintLabelLayoutEntity draft;
  final List<BSFPrintLabelPrinterEntity> printers;

  const BSFPrintLabelLayoutCreateOptionsEntity({
    required this.draft,
    required this.printers,
  });

  @override
  List<Object?> get props => [draft, printers];
}
