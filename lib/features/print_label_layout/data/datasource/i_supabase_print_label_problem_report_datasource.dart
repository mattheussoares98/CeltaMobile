import 'package:celta_inventario/features/print_label_layout/data/models/models.dart';

abstract class ISupabasePrintLabelProblemReportDatasource {
  Future<PrintLabelProblemReportSubmissionResultModel> submit({
    required PrintLabelProblemReportModel report,
    required List<int> physicalLabelWebp,
    required List<int> canvasPreviewWebp,
  });
}
