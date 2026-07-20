import 'package:equatable/equatable.dart';

class LoadAppUsageParams extends Equatable {
  final int? enterpriseId;
  final DateTime startDate;
  final DateTime endDate;

  const LoadAppUsageParams({
    required this.enterpriseId,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [enterpriseId, startDate, endDate];
}
