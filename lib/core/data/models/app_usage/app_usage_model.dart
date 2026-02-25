import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';

class AppUsageModel extends Equatable {
  final String userName;
  final int? enterpriseId;
  final UsageType usageType;
  final int requestCount;
  final String? enterpriseName;

  const AppUsageModel({
    required this.userName,
    required this.enterpriseId,
    required this.usageType,
    required this.requestCount,
    required this.enterpriseName,
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
    'usage_type': usageType.name,
    'request_count': requestCount,
    'enterprise_name': enterpriseName,
  };

  factory AppUsageModel.fromJson(Map map) {
    return AppUsageModel(
      userName: map['user_name'],
      enterpriseId: map['enterprise_id'],
      usageType: UsageType.values.firstWhere(
        (e) => e.name == map['usage_type'],
      ),
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
