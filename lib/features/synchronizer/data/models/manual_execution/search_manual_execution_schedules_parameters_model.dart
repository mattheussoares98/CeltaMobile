// lib/features/synchronizer/data/models/manual_execution/search_manual_execution_schedules_parameters_model.dart
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class SearchManualExecutionSchedulesParametersModel extends Equatable {
  final int enterpriseCode;

  const SearchManualExecutionSchedulesParametersModel({
    required this.enterpriseCode,
  });

  factory SearchManualExecutionSchedulesParametersModel.fromJson(Map json) =>
      SearchManualExecutionSchedulesParametersModel(
        enterpriseCode: json['enterpriseCode'] ?? json['EnterpriseCode'] ?? 0,
      );

  factory SearchManualExecutionSchedulesParametersModel.fromEntity(
    SearchManualExecutionSchedulesParametersEntity entity,
  ) => SearchManualExecutionSchedulesParametersModel(
    enterpriseCode: entity.enterpriseCode,
  );

  Map toJson() => {'enterpriseCode': enterpriseCode};

  SearchManualExecutionSchedulesParametersEntity toEntity() =>
      SearchManualExecutionSchedulesParametersEntity(
        enterpriseCode: enterpriseCode,
      );

  @override
  List<Object?> get props => [enterpriseCode];
}
