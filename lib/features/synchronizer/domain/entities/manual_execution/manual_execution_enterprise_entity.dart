// lib/features/synchronizer/domain/entities/manual_execution/manual_execution_enterprise_entity.dart
import 'package:equatable/equatable.dart';

class ManualExecutionEnterpriseEntity extends Equatable {
  final int code;
  final String name;

  const ManualExecutionEnterpriseEntity({
    required this.code,
    required this.name,
  });

  ManualExecutionEnterpriseEntity copyWith({
    int? code,
    String? name,
  }) {
    return ManualExecutionEnterpriseEntity(
      code: code ?? this.code,
      name: name ?? this.name,
    );
  }

  @override
  List<Object?> get props => [
        code,
        name,
      ];
}
