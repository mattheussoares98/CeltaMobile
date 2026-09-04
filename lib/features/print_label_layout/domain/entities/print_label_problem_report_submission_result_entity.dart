import 'package:equatable/equatable.dart';

class PrintLabelProblemReportSubmissionResultEntity extends Equatable {
  final int schemaVersion;
  final String reportId;
  final DateTime createdAt;
  final bool idempotentReplay;

  const PrintLabelProblemReportSubmissionResultEntity({
    required this.schemaVersion,
    required this.reportId,
    required this.createdAt,
    required this.idempotentReplay,
  });

  @override
  List<Object?> get props => [
    schemaVersion,
    reportId,
    createdAt,
    idempotentReplay,
  ];
}
