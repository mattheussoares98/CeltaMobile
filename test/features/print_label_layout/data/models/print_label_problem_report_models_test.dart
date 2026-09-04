import 'package:celta_inventario/features/print_label_layout/data/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../mocks/mocks.dart';

void main() {
  group('PrintLabelProblemReportModel', () {
    test('should round-trip the entity and JSON without image bytes', () {
      final entity = EntityFactory.makePrintLabelProblemReportEntity();

      final json = PrintLabelProblemReportModel.fromEntity(entity).toJson();
      final result = PrintLabelProblemReportModel.fromJson(json).toEntity();

      expect(result, entity);
      expect(json['layout_snapshot'], isA<Map>());
      expect(json['environment'], isA<Map>());
      expect(json['physical_label'], isA<Map>());
      expect(json['canvas_preview'], isA<Map>());
      expect(json['capture_confirmation'], isA<Map>());
      expect(json.toString(), isNot(contains('base64')));
    });

    test('should accept maps with dynamic keys from local storage', () {
      final entity = EntityFactory.makePrintLabelProblemReportEntity();
      final json = Map<dynamic, dynamic>.from(
        PrintLabelProblemReportModel.fromEntity(entity).toJson(),
      );

      final result = PrintLabelProblemReportModel.fromJson(json).toEntity();

      expect(result, entity);
    });
  });

  test('attachment metadata model should round-trip entity and JSON', () {
    final entity =
        EntityFactory.makePrintLabelProblemReportAttachmentMetadataEntity();
    final model = PrintLabelProblemReportAttachmentMetadataModel.fromEntity(
      entity,
    );

    expect(
      PrintLabelProblemReportAttachmentMetadataModel.fromJson(
        model.toJson(),
      ).toEntity(),
      entity,
    );
  });

  test('environment model should round-trip entity and JSON', () {
    final entity = EntityFactory.makePrintLabelProblemReportEnvironmentEntity();
    final model = PrintLabelProblemReportEnvironmentModel.fromEntity(entity);

    expect(
      PrintLabelProblemReportEnvironmentModel.fromJson(
        model.toJson(),
      ).toEntity(),
      entity,
    );
  });

  test('capture confirmation model should round-trip entity and JSON', () {
    final entity =
        EntityFactory.makePrintLabelProblemReportCaptureConfirmationEntity();
    final model = PrintLabelProblemReportCaptureConfirmationModel.fromEntity(
      entity,
    );

    expect(
      PrintLabelProblemReportCaptureConfirmationModel.fromJson(
        model.toJson(),
      ).toEntity(),
      entity,
    );
  });

  group('PrintLabelProblemReportSubmissionResultModel', () {
    test('should round-trip entity and JSON', () {
      final entity =
          EntityFactory.makePrintLabelProblemReportSubmissionResultEntity(
            idempotentReplay: true,
          );
      final model = PrintLabelProblemReportSubmissionResultModel.fromEntity(
        entity,
      );

      expect(
        PrintLabelProblemReportSubmissionResultModel.fromJson(
          model.toJson(),
        ).toEntity(),
        entity,
      );
    });

    test(
      'should default nullable idempotent replay response field to false',
      () {
        final entity =
            EntityFactory.makePrintLabelProblemReportSubmissionResultEntity();
        final json = PrintLabelProblemReportSubmissionResultModel.fromEntity(
          entity,
        ).toJson()..remove('idempotent_replay');

        final result = PrintLabelProblemReportSubmissionResultModel.fromJson(
          json,
        );

        expect(result.idempotentReplay, isFalse);
      },
    );
  });
}
