// lib/features/synchronizer/domain/entities/manual_execution/execute_manual_schedule_parameters_entity.dart
import 'package:equatable/equatable.dart';

class ExecuteManualScheduleParametersEntity extends Equatable {
  final int enterpriseCode;
  final int scheduleCode;

  const ExecuteManualScheduleParametersEntity({
    required this.enterpriseCode,
    required this.scheduleCode,
  });

  ExecuteManualScheduleParametersEntity copyWith({
    int? enterpriseCode,
    int? scheduleCode,
  }) {
    return ExecuteManualScheduleParametersEntity(
      enterpriseCode: enterpriseCode ?? this.enterpriseCode,
      scheduleCode: scheduleCode ?? this.scheduleCode,
    );
  }

  @override
  List<Object?> get props => [enterpriseCode, scheduleCode];
}
