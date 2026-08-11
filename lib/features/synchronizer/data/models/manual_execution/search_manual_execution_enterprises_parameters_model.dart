// lib/features/synchronizer/data/models/manual_execution/search_manual_execution_enterprises_parameters_model.dart
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class SearchManualExecutionEnterprisesParametersModel extends Equatable {
  final List<int> enterpriseCodes;

  const SearchManualExecutionEnterprisesParametersModel({
    required this.enterpriseCodes,
  });

  factory SearchManualExecutionEnterprisesParametersModel.fromJson(Map json) =>
      SearchManualExecutionEnterprisesParametersModel(
        enterpriseCodes:
            (json['EnterpriseCodes'] as List?)?.map((e) => e as int).toList() ??
            [],
      );

  factory SearchManualExecutionEnterprisesParametersModel.fromEntity(
    SearchManualExecutionEnterprisesParamsEntity entity,
  ) => SearchManualExecutionEnterprisesParametersModel(
    enterpriseCodes: entity.enterpriseCodes,
  );

  Map<String, dynamic> toJson() => {'EnterpriseCodes': enterpriseCodes};

  SearchManualExecutionEnterprisesParamsEntity toEntity() =>
      SearchManualExecutionEnterprisesParamsEntity(
        enterpriseCodes: enterpriseCodes,
      );

  @override
  List<Object?> get props => [enterpriseCodes];
}
