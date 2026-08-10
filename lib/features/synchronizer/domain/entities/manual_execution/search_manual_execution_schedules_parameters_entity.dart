// lib/features/synchronizer/domain/entities/manual_execution/search_manual_execution_schedules_parameters_entity.dart
import 'package:equatable/equatable.dart';

class SearchManualExecutionSchedulesParametersEntity extends Equatable {
  final int enterpriseCode;

  const SearchManualExecutionSchedulesParametersEntity({
    required this.enterpriseCode,
  });

  SearchManualExecutionSchedulesParametersEntity copyWith({
    int? enterpriseCode,
  }) {
    return SearchManualExecutionSchedulesParametersEntity(
      enterpriseCode: enterpriseCode ?? this.enterpriseCode,
    );
  }

  @override
  List<Object?> get props => [enterpriseCode];
}
