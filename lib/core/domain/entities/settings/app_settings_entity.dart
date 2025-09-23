import 'package:equatable/equatable.dart';

import 'settings.dart';

class AppSettingsEntity extends Equatable {
  final SearchProductTypePreference searchPreference;
  final bool isContinuousScanEnabledInInventory;

  const AppSettingsEntity({
    required this.searchPreference,
    required this.isContinuousScanEnabledInInventory,
  });

  @override
  List<Object?> get props => [
    searchPreference,
    isContinuousScanEnabledInInventory,
  ];
}
