import 'package:celta_inventario/core/domain/entities/entities.dart';

import 'app_usage.dart';

class GroupedUsageModel extends GroupedUsageEntity {
  const GroupedUsageModel({
    super.enterpriseName,
    required super.requests,
    required super.enterpriseId,
  });

  @override
  List<Object?> get props => [enterpriseName, requests, enterpriseId];

  Map<String, dynamic> toJson() => {
    'enterprise_name': enterpriseName,
    'enterprise_id': enterpriseId,
    'requests': requests.map((e) => (e as AppUsageModel).toJson()).toList(),
  };

  factory GroupedUsageModel.fromJson(Map map) {
    return GroupedUsageModel(
      enterpriseName: map['enterprise_name'],
      enterpriseId: map['enterprise_id'],
      requests: (map['requests'] as List)
          .map((e) => AppUsageModel.fromJson(e))
          .toList(),
    );
  }

  GroupedUsageEntity toEntity() => GroupedUsageEntity(
    enterpriseName: enterpriseName,
    enterpriseId: enterpriseId,
    requests: requests,
  );

  factory GroupedUsageModel.fromEntity(GroupedUsageEntity entity) {
    return GroupedUsageModel(
      enterpriseName: entity.enterpriseName,
      enterpriseId: entity.enterpriseId,
      requests: entity.requests
          .map((e) => AppUsageModel.fromEntity(e))
          .toList(),
    );
  }
}
