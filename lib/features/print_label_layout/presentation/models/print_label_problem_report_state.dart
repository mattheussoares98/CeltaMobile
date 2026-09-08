import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/models/models.dart';
import 'package:equatable/equatable.dart';

class PrintLabelProblemReportState extends Equatable {
  final PrintLabelProblemReportStage stage;
  final String idempotencyKey;
  final int supabaseEnterpriseId;
  final int erpEnterpriseCode;
  final String erpUserName;
  final String erpEnterpriseName;
  final BSFPrintLabelLayoutEntity savedLayout;
  final PrintLabelProblemReportEnvironmentEntity environment;
  final String description;
  final PrintLabelProblemReportPreparedImageEntity? physicalLabel;
  final PrintLabelProblemReportPreparedImageEntity? canvasPreview;
  final PrintLabelProblemReportCaptureConfirmationEntity captureConfirmation;
  final PrintLabelProblemReportSubmissionResultEntity? result;
  final Object? error;
  final StackTrace? stackTrace;

  const PrintLabelProblemReportState({
    required this.stage,
    required this.idempotencyKey,
    required this.supabaseEnterpriseId,
    required this.erpEnterpriseCode,
    required this.erpUserName,
    required this.erpEnterpriseName,
    required this.savedLayout,
    required this.environment,
    required this.description,
    required this.captureConfirmation,
    this.physicalLabel,
    this.canvasPreview,
    this.result,
    this.error,
    this.stackTrace,
  });

  bool get isSubmitting => stage == PrintLabelProblemReportStage.submitting;

  Iterable<String> get temporaryFilePaths => [
    if (physicalLabel != null) physicalLabel!.filePath,
    if (canvasPreview != null) canvasPreview!.filePath,
  ];

  PrintLabelProblemReportState copyWith({
    PrintLabelProblemReportStage? stage,
    String? description,
    PrintLabelProblemReportPreparedImageEntity? physicalLabel,
    PrintLabelProblemReportPreparedImageEntity? canvasPreview,
    PrintLabelProblemReportCaptureConfirmationEntity? captureConfirmation,
    PrintLabelProblemReportSubmissionResultEntity? result,
    Object? error,
    StackTrace? stackTrace,
    bool clearResult = false,
    bool clearError = false,
  }) => PrintLabelProblemReportState(
    stage: stage ?? this.stage,
    idempotencyKey: idempotencyKey,
    supabaseEnterpriseId: supabaseEnterpriseId,
    erpEnterpriseCode: erpEnterpriseCode,
    erpUserName: erpUserName,
    erpEnterpriseName: erpEnterpriseName,
    savedLayout: savedLayout,
    environment: environment,
    description: description ?? this.description,
    physicalLabel: physicalLabel ?? this.physicalLabel,
    canvasPreview: canvasPreview ?? this.canvasPreview,
    captureConfirmation: captureConfirmation ?? this.captureConfirmation,
    result: clearResult ? null : result ?? this.result,
    error: clearError ? null : error ?? this.error,
    stackTrace: clearError ? null : stackTrace ?? this.stackTrace,
  );

  @override
  List<Object?> get props => [
    stage,
    idempotencyKey,
    supabaseEnterpriseId,
    erpEnterpriseCode,
    erpUserName,
    erpEnterpriseName,
    savedLayout,
    environment,
    description,
    physicalLabel,
    canvasPreview,
    captureConfirmation,
    result,
    error,
    stackTrace,
  ];
}
