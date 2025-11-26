import 'package:equatable/equatable.dart';

import 'entities.dart';

class ReportScheduleExecutionsEntity extends Equatable {
  final int ReportScheduleCode;
  final String LastExecutionStatus;
  final List<ExecutionsEntity> Executions;

  const ReportScheduleExecutionsEntity({
    required this.ReportScheduleCode,
    required this.LastExecutionStatus,
    required this.Executions,
  });

  @override
  List<Object?> get props => [
    ReportScheduleCode,
    LastExecutionStatus,
    Executions,
  ];
}
