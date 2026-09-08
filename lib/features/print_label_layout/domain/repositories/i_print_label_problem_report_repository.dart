import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';

abstract class IPrintLabelProblemReportRepository {
  Future<List<ReportedPrintLabelProblemEntity>> getAll();

  Future<PrintLabelProblemReportSubmissionResultEntity> submit({
    required PrintLabelProblemReportEntity report,
    required List<int> physicalLabelWebp,
    required List<int> canvasPreviewWebp,
  });
}
