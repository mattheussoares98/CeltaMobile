import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';

class PrintLabelProblemReportSubmissionResultModel
    extends PrintLabelProblemReportSubmissionResultEntity {
  const PrintLabelProblemReportSubmissionResultModel({
    required super.schemaVersion,
    required super.reportId,
    required super.createdAt,
    required super.idempotentReplay,
  });

  factory PrintLabelProblemReportSubmissionResultModel.fromJson(Map json) =>
      PrintLabelProblemReportSubmissionResultModel(
        schemaVersion: (json['schema_version'] as num).toInt(),
        reportId: json['report_id'] as String,
        createdAt: DateTime.parse(json['created_at'] as String),
        idempotentReplay: json['idempotent_replay'] as bool? ?? false,
      );

  factory PrintLabelProblemReportSubmissionResultModel.fromEntity(
    PrintLabelProblemReportSubmissionResultEntity entity,
  ) => PrintLabelProblemReportSubmissionResultModel(
    schemaVersion: entity.schemaVersion,
    reportId: entity.reportId,
    createdAt: entity.createdAt,
    idempotentReplay: entity.idempotentReplay,
  );

  Map toJson() => {
    'schema_version': schemaVersion,
    'report_id': reportId,
    'created_at': createdAt.toUtc().toIso8601String(),
    'idempotent_replay': idempotentReplay,
  };

  PrintLabelProblemReportSubmissionResultEntity toEntity() =>
      PrintLabelProblemReportSubmissionResultEntity(
        schemaVersion: schemaVersion,
        reportId: reportId,
        createdAt: createdAt,
        idempotentReplay: idempotentReplay,
      );
}
