import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class PrintLabelProblemReportEntity extends Equatable {
  final int schemaVersion;
  final String idempotencyKey;
  final int supabaseEnterpriseId;
  final int erpEnterpriseCode;
  final String erpUserName;
  final String erpEnterpriseName;
  final String description;
  final BSFPrintLabelLayoutEntity savedLayout;
  final PrintLabelProblemReportEnvironmentEntity environment;
  final PrintLabelProblemReportAttachmentMetadataEntity physicalLabel;
  final PrintLabelProblemReportAttachmentMetadataEntity canvasPreview;
  final PrintLabelProblemReportCaptureConfirmationEntity captureConfirmation;

  const PrintLabelProblemReportEntity({
    required this.schemaVersion,
    required this.idempotencyKey,
    required this.supabaseEnterpriseId,
    required this.erpEnterpriseCode,
    required this.erpUserName,
    required this.erpEnterpriseName,
    required this.description,
    required this.savedLayout,
    required this.environment,
    required this.physicalLabel,
    required this.canvasPreview,
    required this.captureConfirmation,
  });

  @override
  List<Object?> get props => [
    schemaVersion,
    idempotencyKey,
    supabaseEnterpriseId,
    erpEnterpriseCode,
    erpUserName,
    erpEnterpriseName,
    description,
    savedLayout,
    environment,
    physicalLabel,
    canvasPreview,
    captureConfirmation,
  ];
}
