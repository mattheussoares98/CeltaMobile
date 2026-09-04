import 'package:flutter_test/flutter_test.dart';

import '../../../../mocks/mocks.dart';

void main() {
  test('report equality includes every nested domain value', () {
    final first = EntityFactory.makePrintLabelProblemReportEntity();
    final equal = EntityFactory.makePrintLabelProblemReportEntity(
      schemaVersion: first.schemaVersion,
      idempotencyKey: first.idempotencyKey,
      supabaseEnterpriseId: first.supabaseEnterpriseId,
      erpEnterpriseCode: first.erpEnterpriseCode,
      erpUserName: first.erpUserName,
      erpEnterpriseName: first.erpEnterpriseName,
      description: first.description,
      savedLayout: first.savedLayout,
      environment: first.environment,
      physicalLabel: first.physicalLabel,
      canvasPreview: first.canvasPreview,
      captureConfirmation: first.captureConfirmation,
    );

    expect(equal, first);
    expect(
      EntityFactory.makePrintLabelProblemReportEntity(
        description: '${first.description} changed',
      ),
      isNot(first),
    );
  });

  test('capture confirmation requires both confirmations', () {
    expect(
      EntityFactory.makePrintLabelProblemReportCaptureConfirmationEntity()
          .isConfirmed,
      isTrue,
    );
    expect(
      EntityFactory.makePrintLabelProblemReportCaptureConfirmationEntity(
        canvasPreviewRepresentsSavedLayout: false,
      ).isConfirmed,
      isFalse,
    );
  });

  test('submission result equality includes replay state', () {
    final result =
        EntityFactory.makePrintLabelProblemReportSubmissionResultEntity();

    expect(
      EntityFactory.makePrintLabelProblemReportSubmissionResultEntity(
        schemaVersion: result.schemaVersion,
        reportId: result.reportId,
        createdAt: result.createdAt,
        idempotentReplay: result.idempotentReplay,
      ),
      result,
    );
    expect(
      EntityFactory.makePrintLabelProblemReportSubmissionResultEntity(
        schemaVersion: result.schemaVersion,
        reportId: result.reportId,
        createdAt: result.createdAt,
        idempotentReplay: true,
      ),
      isNot(result),
    );
  });
}
