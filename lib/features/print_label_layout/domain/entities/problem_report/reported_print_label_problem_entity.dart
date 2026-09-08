import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class ReportedPrintLabelProblemEntity extends Equatable {
  final String id;
  final DateTime createdAt;
  final String status;
  final PrintLabelProblemReportEntity report;
  final String physicalLabelUrl;
  final String canvasPreviewUrl;

  const ReportedPrintLabelProblemEntity({
    required this.id,
    required this.createdAt,
    required this.status,
    required this.report,
    required this.physicalLabelUrl,
    required this.canvasPreviewUrl,
  });

  @override
  List<Object?> get props => [
    id,
    createdAt,
    status,
    report,
    physicalLabelUrl,
    canvasPreviewUrl,
  ];
}
