// lib/features/synchronizer/domain/entities/manual_execution/manual_execution_schedule_entity.dart
import 'package:equatable/equatable.dart';

class ManualExecutionScheduleEntity extends Equatable {
  final int code;
  final String name;
  final DateTime? dateOfLastExecution;

  const ManualExecutionScheduleEntity({
    required this.code,
    required this.name,
    this.dateOfLastExecution,
  });

  ManualExecutionScheduleEntity copyWith({
    int? code,
    String? name,
    DateTime? dateOfLastExecution,
  }) {
    return ManualExecutionScheduleEntity(
      code: code ?? this.code,
      name: name ?? this.name,
      dateOfLastExecution: dateOfLastExecution ?? this.dateOfLastExecution,
    );
  }

  @override
  List<Object?> get props => [
        code,
        name,
        dateOfLastExecution,
      ];
}
