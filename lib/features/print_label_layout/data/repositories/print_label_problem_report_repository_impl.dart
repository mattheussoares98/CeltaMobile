import 'package:celta_inventario/features/print_label_layout/data/datasource/datasource.dart';
import 'package:celta_inventario/features/print_label_layout/data/models/models.dart';
import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/domain/repositories/repositories.dart';

class PrintLabelProblemReportRepositoryImpl
    implements IPrintLabelProblemReportRepository {
  final ISupabasePrintLabelProblemReportDatasource datasource;

  const PrintLabelProblemReportRepositoryImpl(this.datasource);

  @override
  Future<PrintLabelProblemReportSubmissionResultEntity> submit({
    required PrintLabelProblemReportEntity report,
    required List<int> physicalLabelWebp,
    required List<int> canvasPreviewWebp,
  }) async {
    final result = await datasource.submit(
      report: PrintLabelProblemReportModel.fromEntity(report),
      physicalLabelWebp: physicalLabelWebp,
      canvasPreviewWebp: canvasPreviewWebp,
    );
    return result.toEntity();
  }
}
