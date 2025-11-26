import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';
import 'models.dart';

class ReportScheduleExecutionsModel extends Equatable {
  final int ReportScheduleCode;
  final String LastExecutionStatus;
  final List<ExecutionsModel> Executions;

  const ReportScheduleExecutionsModel({
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

  factory ReportScheduleExecutionsModel.fromJson(Map json) {
    final executionsList =
        (json['Executions'] as List<dynamic>?)
            ?.map((e) => ExecutionsModel.fromJson(e as Map))
            .toList() ??
        [];

    return ReportScheduleExecutionsModel(
      ReportScheduleCode: json['ReportScheduleCode'] as int,
      LastExecutionStatus: json['LastExecutionStatus'] as String,
      Executions: executionsList,
    );
  }

  factory ReportScheduleExecutionsModel.fromEntity(
    ReportScheduleExecutionsEntity entity,
  ) {
    return ReportScheduleExecutionsModel(
      ReportScheduleCode: entity.ReportScheduleCode,
      LastExecutionStatus: entity.LastExecutionStatus,
      Executions: entity.Executions.map(
        (e) => ExecutionsModel.fromEntity(e),
      ).toList(),
    );
  }

  ReportScheduleExecutionsEntity toEntity() {
    return ReportScheduleExecutionsEntity(
      ReportScheduleCode: ReportScheduleCode,
      LastExecutionStatus: LastExecutionStatus,
      Executions: Executions.map((e) => e.toEntity()).toList(),
    );
  }
}
