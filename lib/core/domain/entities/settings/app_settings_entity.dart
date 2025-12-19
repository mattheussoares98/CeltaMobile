// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'settings.dart';

class AppSettingsEntity extends Equatable {
  final SearchProductTypePreference searchPreference;
  final bool inventoryUseContinuousScan;
  final bool expeditionUseContinuousScan;

  const AppSettingsEntity({
    required this.searchPreference,
    required this.inventoryUseContinuousScan,
    required this.expeditionUseContinuousScan,
  });

  @override
  List<Object?> get props => [
    searchPreference,
    inventoryUseContinuousScan,
    expeditionUseContinuousScan,
  ];

  AppSettingsEntity copyWith({
    SearchProductTypePreference? searchPreference,
    bool? inventoryUseContinuousScan,
    bool? expeditionUseContinuousScan,
  }) {
    return AppSettingsEntity(
      searchPreference: searchPreference ?? this.searchPreference,
      inventoryUseContinuousScan:
          inventoryUseContinuousScan ?? this.inventoryUseContinuousScan,
      expeditionUseContinuousScan:
          expeditionUseContinuousScan ?? this.expeditionUseContinuousScan,
    );
  }
}
