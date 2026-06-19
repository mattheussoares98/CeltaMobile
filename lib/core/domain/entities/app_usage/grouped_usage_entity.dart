// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:celta_inventario/core/domain/entities/app_usage/app_usage.dart';
import 'package:equatable/equatable.dart';

class GroupedUsageEntity extends Equatable {
  final String? enterpriseName; //receive when load the reports
  final List<AppUsageEntity> requests;
  final int? enterpriseId;

  const GroupedUsageEntity({
    required this.enterpriseName,
    required this.requests,
    required this.enterpriseId,
  });

  @override
  List<Object?> get props => [enterpriseName, requests, enterpriseId];

  GroupedUsageEntity copyWith({
    String? enterpriseName,
    List<AppUsageEntity>? usages,
    int? enterpriseId,
  }) {
    return GroupedUsageEntity(
      enterpriseName: enterpriseName ?? this.enterpriseName,
      requests: usages ?? this.requests,
      enterpriseId: enterpriseId ?? this.enterpriseId,
    );
  }
}
