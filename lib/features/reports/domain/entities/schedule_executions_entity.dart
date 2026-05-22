import 'package:equatable/equatable.dart';

import 'package:celta_inventario/features/reports/domain/entities/entities.dart';

class ScheduleExecutionsEntity extends Equatable {
  final int ReportScheduleCode;
  final String LastExecutionStatus;
  final List<ExecutionsEntity> Executions;

  const ScheduleExecutionsEntity({
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
