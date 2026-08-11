// lib/features/synchronizer/domain/entities/manual_execution/search_manual_execution_enterprises_parameters_entity.dart
import 'package:equatable/equatable.dart';

class SearchManualExecutionEnterprisesParamsEntity extends Equatable {
  final List<int> enterpriseCodes;

  const SearchManualExecutionEnterprisesParamsEntity({
    required this.enterpriseCodes,
  });

  SearchManualExecutionEnterprisesParamsEntity copyWith({
    List<int>? enterpriseCodes,
  }) {
    return SearchManualExecutionEnterprisesParamsEntity(
      enterpriseCodes: enterpriseCodes ?? this.enterpriseCodes,
    );
  }

  @override
  List<Object?> get props => [enterpriseCodes];
}
