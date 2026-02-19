import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';

class AppUsageModel extends Equatable {
  final String userName;
  final int? enterpriseId;
  final UsageType usageType;
  final int requestCount;

  const AppUsageModel({
    required this.userName,
    required this.enterpriseId,
    required this.usageType,
    required this.requestCount,
  });

  @override
  List<Object?> get props => [userName, enterpriseId, usageType, requestCount];

  Map<String, dynamic> toJson() => {
    'user_name': userName,
    'enterprise_id': enterpriseId,
    'usage_type': usageType.name,
    'request_count': requestCount,
  };

  factory AppUsageModel.fromJson(Map map) {
    return AppUsageModel(
      userName: map['user_name'],
      enterpriseId: map['enterprise_id'],
      usageType: UsageType.values.firstWhere(
        (e) => e.name == map['usage_type'],
      ),
      requestCount: map['request_count'],
    );
  }

  AppUsageEntity toEntity() => AppUsageEntity(
    userName: userName,
    enterpriseId: enterpriseId,
    usageType: usageType,
    requestCount: requestCount,
  );

  factory AppUsageModel.fromEntity(AppUsageEntity entity) {
    return AppUsageModel(
      userName: entity.userName,
      enterpriseId: entity.enterpriseId,
      usageType: entity.usageType,
      requestCount: entity.requestCount,
    );
  }
}
