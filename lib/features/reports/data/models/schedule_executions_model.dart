import 'package:equatable/equatable.dart';

import 'package:celta_inventario/features/reports/domain/entities/entities.dart';
import 'package:celta_inventario/features/reports/data/models/models.dart';

class ScheduleExecutionsModel extends Equatable {
  final int ReportScheduleCode;
  final String LastExecutionStatus;
  final List<ExecutionsModel> Executions;

  const ScheduleExecutionsModel({
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

  Map toJson() => {
    'ReportScheduleCode': ReportScheduleCode,
    'LastExecutionStatus': LastExecutionStatus,
    'Executions': Executions.map((e) => e.toJson()).toList(),
  };

  factory ScheduleExecutionsModel.fromJson(Map json) {
    final executionsList =
        (json['Executions'] as List<dynamic>?)
            ?.map((e) => ExecutionsModel.fromJson(e as Map))
            .toList() ??
        [];

    return ScheduleExecutionsModel(
      ReportScheduleCode: json['ReportScheduleCode'] as int,
      LastExecutionStatus: json['LastExecutionStatus'] as String,
      Executions: executionsList,
    );
  }

  factory ScheduleExecutionsModel.fromEntity(ScheduleExecutionsEntity entity) {
    return ScheduleExecutionsModel(
      ReportScheduleCode: entity.ReportScheduleCode,
      LastExecutionStatus: entity.LastExecutionStatus,
      Executions: entity.Executions.map(
        (e) => ExecutionsModel.fromEntity(e),
      ).toList(),
    );
  }

  ScheduleExecutionsEntity toEntity() {
    return ScheduleExecutionsEntity(
      ReportScheduleCode: ReportScheduleCode,
      LastExecutionStatus: LastExecutionStatus,
      Executions: Executions.map((e) => e.toEntity()).toList(),
    );
  }
}
