import 'package:celta_inventario/features/print_label_layout/data/models/models.dart';
import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';

class PrintLabelProblemReportModel extends PrintLabelProblemReportEntity {
  const PrintLabelProblemReportModel({
    required super.schemaVersion,
    required super.idempotencyKey,
    required super.supabaseEnterpriseId,
    required super.erpEnterpriseCode,
    required super.erpUserName,
    required super.erpEnterpriseName,
    required super.description,
    required super.savedLayout,
    required super.environment,
    required super.physicalLabel,
    required super.canvasPreview,
    required super.captureConfirmation,
  });

  factory PrintLabelProblemReportModel.fromJson(Map json) =>
      PrintLabelProblemReportModel(
        schemaVersion: (json['schema_version'] as num).toInt(),
        idempotencyKey: json['idempotency_key'] as String,
        supabaseEnterpriseId: (json['supabase_enterprise_id'] as num).toInt(),
        erpEnterpriseCode: (json['erp_enterprise_code'] as num).toInt(),
        erpUserName: json['erp_user_name'] as String,
        erpEnterpriseName: json['erp_enterprise_name'] as String,
        description: json['description'] as String,
        savedLayout: BSFPrintLabelLayoutModel.fromJson(
          json['layout_snapshot'] as Map,
        ).toEntity(),
        environment: PrintLabelProblemReportEnvironmentModel.fromJson(
          json['environment'] as Map,
        ).toEntity(),
        physicalLabel: PrintLabelProblemReportAttachmentMetadataModel.fromJson(
          json['physical_label'] as Map,
        ).toEntity(),
        canvasPreview: PrintLabelProblemReportAttachmentMetadataModel.fromJson(
          json['canvas_preview'] as Map,
        ).toEntity(),
        captureConfirmation:
            PrintLabelProblemReportCaptureConfirmationModel.fromJson(
              json['capture_confirmation'] as Map,
            ).toEntity(),
      );

  factory PrintLabelProblemReportModel.fromEntity(
    PrintLabelProblemReportEntity entity,
  ) => PrintLabelProblemReportModel(
    schemaVersion: entity.schemaVersion,
    idempotencyKey: entity.idempotencyKey,
    supabaseEnterpriseId: entity.supabaseEnterpriseId,
    erpEnterpriseCode: entity.erpEnterpriseCode,
    erpUserName: entity.erpUserName,
    erpEnterpriseName: entity.erpEnterpriseName,
    description: entity.description,
    savedLayout: entity.savedLayout,
    environment: entity.environment,
    physicalLabel: entity.physicalLabel,
    canvasPreview: entity.canvasPreview,
    captureConfirmation: entity.captureConfirmation,
  );

  Map toJson() => {
    'schema_version': schemaVersion,
    'idempotency_key': idempotencyKey,
    'supabase_enterprise_id': supabaseEnterpriseId,
    'erp_enterprise_code': erpEnterpriseCode,
    'erp_user_name': erpUserName,
    'erp_enterprise_name': erpEnterpriseName,
    'description': description,
    'layout_snapshot': BSFPrintLabelLayoutModel.fromEntity(
      savedLayout,
    ).toJson(),
    'environment': PrintLabelProblemReportEnvironmentModel.fromEntity(
      environment,
    ).toJson(),
    'physical_label': PrintLabelProblemReportAttachmentMetadataModel.fromEntity(
      physicalLabel,
    ).toJson(),
    'canvas_preview': PrintLabelProblemReportAttachmentMetadataModel.fromEntity(
      canvasPreview,
    ).toJson(),
    'capture_confirmation':
        PrintLabelProblemReportCaptureConfirmationModel.fromEntity(
          captureConfirmation,
        ).toJson(),
  };

  PrintLabelProblemReportEntity toEntity() => PrintLabelProblemReportEntity(
    schemaVersion: schemaVersion,
    idempotencyKey: idempotencyKey,
    supabaseEnterpriseId: supabaseEnterpriseId,
    erpEnterpriseCode: erpEnterpriseCode,
    erpUserName: erpUserName,
    erpEnterpriseName: erpEnterpriseName,
    description: description,
    savedLayout: savedLayout,
    environment: environment,
    physicalLabel: physicalLabel,
    canvasPreview: canvasPreview,
    captureConfirmation: captureConfirmation,
  );
}
