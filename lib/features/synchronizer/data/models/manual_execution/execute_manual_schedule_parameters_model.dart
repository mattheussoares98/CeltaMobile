// lib/features/synchronizer/data/models/manual_execution/execute_manual_schedule_parameters_model.dart
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class ExecuteManualScheduleParametersModel extends Equatable {
  final int enterpriseCode;
  final int scheduleCode;

  const ExecuteManualScheduleParametersModel({
    required this.enterpriseCode,
    required this.scheduleCode,
  });

  factory ExecuteManualScheduleParametersModel.fromJson(Map json) =>
      ExecuteManualScheduleParametersModel(
        enterpriseCode: json['enterpriseCode'] ?? json['EnterpriseCode'] ?? 0,
        scheduleCode: json['scheduleCode'] ?? json['ScheduleCode'] ?? 0,
      );

  factory ExecuteManualScheduleParametersModel.fromEntity(
    ExecuteManualScheduleParametersEntity entity,
  ) => ExecuteManualScheduleParametersModel(
    enterpriseCode: entity.enterpriseCode,
    scheduleCode: entity.scheduleCode,
  );

  Map toJson() => {
    'enterpriseCode': enterpriseCode,
    'scheduleCode': scheduleCode,
  };

  ExecuteManualScheduleParametersEntity toEntity() =>
      ExecuteManualScheduleParametersEntity(
        enterpriseCode: enterpriseCode,
        scheduleCode: scheduleCode,
      );

  @override
  List<Object?> get props => [enterpriseCode, scheduleCode];
}
