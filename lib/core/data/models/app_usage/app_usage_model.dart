import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:collection/collection.dart';

class AppUsageModel extends AppUsageEntity {
  const AppUsageModel({
    required super.userName,
    required super.enterpriseId,
    required super.usageType,
    required super.requestCount,
    required super.enterpriseName,
  });

  @override
  List<Object?> get props => [
    userName,
    enterpriseId,
    usageType,
    requestCount,
    enterpriseName,
  ];

  Map<String, dynamic> toJson() => {
    'user_name': userName,
    'enterprise_id': enterpriseId,
    'usage_type': usageType?.name,
    'request_count': requestCount,
    'enterprise_name': enterpriseName,
  };

  factory AppUsageModel.fromJson(Map map) {
    return AppUsageModel(
      userName: map['user_name'],
      enterpriseId: map['enterprise_id'],
      usageType:
          UsageType.values.firstWhereOrNull(
            (e) =>
                e.name.toLowerCase() ==
                map['usage_type'].toString().toLowerCase(),
          ) ??
          UsageType.notDefined,
      requestCount: map['request_count'],
      enterpriseName: map['enterprise_name'],
    );
  }

  AppUsageEntity toEntity() => AppUsageEntity(
    userName: userName,
    enterpriseId: enterpriseId,
    usageType: usageType,
    requestCount: requestCount,
    enterpriseName: enterpriseName,
  );

  factory AppUsageModel.fromEntity(AppUsageEntity entity) {
    return AppUsageModel(
      userName: entity.userName,
      enterpriseId: entity.enterpriseId,
      usageType: entity.usageType,
      requestCount: entity.requestCount,
      enterpriseName: entity.enterpriseName,
    );
  }
}
