import 'package:celta_inventario/features/print_label_layout/data/datasource/datasource.dart';
import 'package:celta_inventario/features/print_label_layout/data/models/models.dart';
import 'package:celta_inventario/features/print_label_layout/data/repositories/repositories.dart';
import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/domain/repositories/repositories.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class MockSupabasePrintLabelProblemReportDatasource extends Mock
    implements ISupabasePrintLabelProblemReportDatasource {}

void main() {
  late IPrintLabelProblemReportRepository sut;
  late MockSupabasePrintLabelProblemReportDatasource datasource;
  late PrintLabelProblemReportEntity report;
  late PrintLabelProblemReportModel reportModel;
  late PrintLabelProblemReportSubmissionResultEntity resultEntity;
  late PrintLabelProblemReportSubmissionResultModel resultModel;
  late List<int> physicalLabelWebp;
  late List<int> canvasPreviewWebp;

  setUp(() {
    datasource = MockSupabasePrintLabelProblemReportDatasource();
    sut = PrintLabelProblemReportRepositoryImpl(datasource);
    report = EntityFactory.makePrintLabelProblemReportEntity();
    reportModel = PrintLabelProblemReportModel.fromEntity(report);
    resultEntity =
        EntityFactory.makePrintLabelProblemReportSubmissionResultEntity();
    resultModel = PrintLabelProblemReportSubmissionResultModel.fromEntity(
      resultEntity,
    );
    physicalLabelWebp = [1, 2, 3];
    canvasPreviewWebp = [4, 5, 6];
  });

  test('submit delegates exact values and returns the result entity', () async {
    when(
      () => datasource.submit(
        report: reportModel,
        physicalLabelWebp: physicalLabelWebp,
        canvasPreviewWebp: canvasPreviewWebp,
      ),
    ).thenAnswer((_) async => resultModel);

    final result = await sut.submit(
      report: report,
      physicalLabelWebp: physicalLabelWebp,
      canvasPreviewWebp: canvasPreviewWebp,
    );

    expect(result, resultEntity);
    verify(
      () => datasource.submit(
        report: reportModel,
        physicalLabelWebp: physicalLabelWebp,
        canvasPreviewWebp: canvasPreviewWebp,
      ),
    ).called(1);
    verifyNoMoreInteractions(datasource);
  });

  test('submit propagates the datasource error unchanged', () async {
    final exception = Exception('Failed to submit print-label problem report');
    when(
      () => datasource.submit(
        report: reportModel,
        physicalLabelWebp: physicalLabelWebp,
        canvasPreviewWebp: canvasPreviewWebp,
      ),
    ).thenThrow(exception);

    final call = sut.submit(
      report: report,
      physicalLabelWebp: physicalLabelWebp,
      canvasPreviewWebp: canvasPreviewWebp,
    );

    await expectLater(call, throwsA(same(exception)));
    verify(
      () => datasource.submit(
        report: reportModel,
        physicalLabelWebp: physicalLabelWebp,
        canvasPreviewWebp: canvasPreviewWebp,
      ),
    ).called(1);
    verifyNoMoreInteractions(datasource);
  });
}
