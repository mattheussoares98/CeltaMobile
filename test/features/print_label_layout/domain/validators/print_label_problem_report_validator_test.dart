import 'package:celta_inventario/features/print_label_layout/domain/validators/validators.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../mocks/mocks.dart';

void main() {
  test('accepts a complete saved-layout report', () {
    final report = EntityFactory.makePrintLabelProblemReportEntity();

    expect(PrintLabelProblemReportValidator.validate(report), isEmpty);
  });

  test('rejects invalid contract and identity values', () {
    final report = EntityFactory.makePrintLabelProblemReportEntity(
      schemaVersion: 2,
      idempotencyKey: 'invalid',
      supabaseEnterpriseId: 0,
      erpEnterpriseCode: 0,
      erpUserName: ' ',
      erpEnterpriseName: ' ',
      description: ' ',
      savedLayout: EntityFactory.makeBSFPrintLabelLayoutEntity(code: 0),
    );

    final errors = PrintLabelProblemReportValidator.validate(report);

    expect(errors, contains('Unsupported schema version'));
    expect(errors, contains('Idempotency key must be a UUID'));
    expect(errors, contains('Supabase enterprise must be informed'));
    expect(errors, contains('ERP enterprise must be informed'));
    expect(errors, contains('ERP user name must be informed'));
    expect(errors, contains('ERP enterprise name must be informed'));
    expect(errors, contains('Description must be informed'));
    expect(errors, contains('Only a saved layout can be reported'));
  });

  test('rejects incomplete environment and capture confirmation', () {
    final report = EntityFactory.makePrintLabelProblemReportEntity(
      environment: EntityFactory.makePrintLabelProblemReportEnvironmentEntity(
        deviceModel: ' ',
      ),
      captureConfirmation:
          EntityFactory.makePrintLabelProblemReportCaptureConfirmationEntity(
            physicalLabelWasPrintedFromSavedLayout: false,
          ),
    );

    final errors = PrintLabelProblemReportValidator.validate(report);

    expect(errors, contains('Environment must be complete'));
    expect(errors, contains('Both captures must be confirmed'));
  });

  test('rejects attachments outside byte and dimension limits', () {
    final report = EntityFactory.makePrintLabelProblemReportEntity(
      physicalLabel:
          EntityFactory.makePrintLabelProblemReportAttachmentMetadataEntity(
            byteLength: PrintLabelProblemReportValidator.maxImageByteLength + 1,
          ),
      canvasPreview:
          EntityFactory.makePrintLabelProblemReportAttachmentMetadataEntity(
            width: PrintLabelProblemReportValidator.maxImageSide + 1,
          ),
    );

    final errors = PrintLabelProblemReportValidator.validate(report);

    expect(errors, contains('Physical label must contain at most 5 MiB'));
    expect(errors, contains('Canvas preview dimensions are invalid'));
  });

  test('rejects descriptions over the Unicode character limit', () {
    final report = EntityFactory.makePrintLabelProblemReportEntity(
      description: List.filled(
        PrintLabelProblemReportValidator.maxDescriptionLength + 1,
        'á',
      ).join(),
    );

    expect(
      PrintLabelProblemReportValidator.validate(report),
      contains('Description must contain at most 2000 characters'),
    );
  });
}
