// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:celta_inventario/core/domain/entities/app_usage/app_usage.dart';
import 'package:equatable/equatable.dart';

class GroupedUsageEntity extends Equatable {
  final String? enterpriseName; //receive when load the reports
  final List<AppUsageEntity> usages;

  const GroupedUsageEntity({
    required this.enterpriseName,
    required this.usages,
  });

  @override
  List<Object?> get props => [enterpriseName, usages];

  GroupedUsageEntity copyWith({
    String? enterpriseName,
    List<AppUsageEntity>? usages,
  }) {
    return GroupedUsageEntity(
      enterpriseName: enterpriseName ?? this.enterpriseName,
      usages: usages ?? this.usages,
    );
  }
}
