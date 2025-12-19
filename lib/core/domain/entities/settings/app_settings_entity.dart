// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'settings.dart';

class AppSettingsEntity extends Equatable {
  final SearchProductTypePreference searchPreference;
  final bool isContinuousScanEnabledInInventory;
  final bool isContinuousScanEnabledInExpedition;

  const AppSettingsEntity({
    required this.searchPreference,
    required this.isContinuousScanEnabledInInventory,
    required this.isContinuousScanEnabledInExpedition,
  });

  @override
  List<Object?> get props => [
    searchPreference,
    isContinuousScanEnabledInInventory,
    isContinuousScanEnabledInExpedition,
  ];

  AppSettingsEntity copyWith({
    SearchProductTypePreference? searchPreference,
    bool? isContinuousScanEnabledInInventory,
    bool? isContinuousScanEnabledInExpedition,
  }) {
    return AppSettingsEntity(
      searchPreference: searchPreference ?? this.searchPreference,
      isContinuousScanEnabledInInventory:
          isContinuousScanEnabledInInventory ??
          this.isContinuousScanEnabledInInventory,
      isContinuousScanEnabledInExpedition:
          isContinuousScanEnabledInExpedition ??
          this.isContinuousScanEnabledInExpedition,
    );
  }
}
