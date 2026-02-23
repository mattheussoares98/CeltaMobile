// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'app_usage.dart';

class AppUsageEntity extends Equatable {
  final String userName;
  final int? enterpriseId; //when load the usage dont receive this parameter
  final UsageType usageType;
  final int requestCount;

  const AppUsageEntity({
    required this.userName,
    required this.enterpriseId,
    required this.usageType,
    required this.requestCount,
  });

  @override
  List<Object?> get props => [userName, enterpriseId, usageType, requestCount];

  AppUsageEntity copyWith({
    String? userName,
    int? enterpriseId,
    UsageType? usageType,
    int? requestCount,
  }) {
    return AppUsageEntity(
      userName: userName ?? this.userName,
      enterpriseId: enterpriseId ?? this.enterpriseId,
      usageType: usageType ?? this.usageType,
      requestCount: requestCount ?? this.requestCount,
    );
  }
}
