// lib/features/synchronizer/data/models/manual_execution/manual_execution_enterprise_model.dart
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class ManualExecutionEnterpriseModel extends Equatable {
  final int code;
  final String name;

  const ManualExecutionEnterpriseModel({
    required this.code,
    required this.name,
  });

  factory ManualExecutionEnterpriseModel.fromJson(Map json) =>
      ManualExecutionEnterpriseModel(code: json['Code'], name: json['Name']);

  factory ManualExecutionEnterpriseModel.fromEntity(
    ManualExecutionEnterpriseEntity entity,
  ) => ManualExecutionEnterpriseModel(code: entity.code, name: entity.name);

  Map<String, dynamic> toJson() => {'Code': code, 'Name': name};

  ManualExecutionEnterpriseEntity toEntity() =>
      ManualExecutionEnterpriseEntity(code: code, name: name);

  @override
  List<Object?> get props => [code, name];
}
