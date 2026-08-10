// lib/features/synchronizer/data/models/manual_execution/manual_execution_schedule_model.dart
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class ManualExecutionScheduleModel extends Equatable {
  final int code;
  final String name;
  final DateTime? dateOfLastExecution;

  const ManualExecutionScheduleModel({
    required this.code,
    required this.name,
    this.dateOfLastExecution,
  });

  factory ManualExecutionScheduleModel.fromJson(Map json) =>
      ManualExecutionScheduleModel(
        code: json['code'] ?? json['Code'],
        name: json['name'] ?? json['Name'] ?? '',
        dateOfLastExecution:
            json['dateOfLastExecution'] != null ||
                json['DateOfLastExecution'] != null
            ? DateTime.tryParse(
                json['dateOfLastExecution'] ?? json['DateOfLastExecution'],
              )
            : null,
      );

  factory ManualExecutionScheduleModel.fromEntity(
    ManualExecutionScheduleEntity entity,
  ) => ManualExecutionScheduleModel(
    code: entity.code,
    name: entity.name,
    dateOfLastExecution: entity.dateOfLastExecution,
  );

  Map toJson() => {
    'code': code,
    'name': name,
    'dateOfLastExecution': dateOfLastExecution?.toIso8601String(),
  };

  ManualExecutionScheduleEntity toEntity() => ManualExecutionScheduleEntity(
    code: code,
    name: name,
    dateOfLastExecution: dateOfLastExecution,
  );

  @override
  List<Object?> get props => [code, name, dateOfLastExecution];
}
