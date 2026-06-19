import 'package:celta_inventario/core/domain/entities/entities.dart';

import 'app_usage.dart';

class GroupedUsageModel extends GroupedUsageEntity {
  const GroupedUsageModel({super.enterpriseName, required super.usages});

  @override
  List<Object?> get props => [enterpriseName, usages];

  Map<String, dynamic> toJson() => {
    'enterprise_name': enterpriseName,
    'usages': usages.map((e) => (e as AppUsageModel).toJson()).toList(),
  };

  factory GroupedUsageModel.fromJson(Map map) {
    return GroupedUsageModel(
      enterpriseName: map['enterprise_name'],
      usages: (map['usages'] as List<Map>)
          .map((e) => AppUsageModel.fromJson(e))
          .toList(),
    );
  }

  GroupedUsageEntity toEntity() =>
      GroupedUsageEntity(enterpriseName: enterpriseName, usages: usages);

  factory GroupedUsageModel.fromEntity(GroupedUsageEntity entity) {
    return GroupedUsageModel(
      enterpriseName: entity.enterpriseName,
      usages: entity.usages as List<AppUsageModel>,
    );
  }
}
