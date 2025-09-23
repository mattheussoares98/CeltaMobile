// ignore_for_file: public_member_api_docs, sort_constructors_first
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

  AppSettingsEntity copyWith({
    SearchProductTypePreference? searchPreference,
    bool? isContinuousScanEnabledInInventory,
  }) {
    return AppSettingsEntity(
      searchPreference: searchPreference ?? this.searchPreference,
      isContinuousScanEnabledInInventory:
          isContinuousScanEnabledInInventory ??
          this.isContinuousScanEnabledInInventory,
    );
  }
}
