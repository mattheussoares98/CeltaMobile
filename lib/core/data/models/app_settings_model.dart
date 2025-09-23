// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';

class AppSettingsModel extends Equatable {
  final SearchProductTypePreference searchPreference;
  final bool isContinuousScanEnabledInInventory;

  const AppSettingsModel({
    required this.searchPreference,
    required this.isContinuousScanEnabledInInventory,
  });

  @override
  List<Object?> get props => [
    searchPreference,
    isContinuousScanEnabledInInventory,
  ];

  factory AppSettingsModel.fromJson(Map<String, dynamic> json) {
    return AppSettingsModel(
      searchPreference: SearchProductTypePreference.values.firstWhere(
        (element) => element.name == json['searchPreference'],
      ),
      isContinuousScanEnabledInInventory:
          json['isContinuousScanEnabledInInventory'],
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'searchPreference': searchPreference.name,
    'isContinuousScanEnabledInInventory': isContinuousScanEnabledInInventory,
  };

  AppSettingsEntity toEntity() => AppSettingsEntity(
    searchPreference: searchPreference,
    isContinuousScanEnabledInInventory: isContinuousScanEnabledInInventory,
  );

  factory AppSettingsModel.fromEntity(AppSettingsEntity entity) {
    return AppSettingsModel(
      searchPreference: entity.searchPreference,
      isContinuousScanEnabledInInventory:
          entity.isContinuousScanEnabledInInventory,
    );
  }

  AppSettingsModel copyWith({
    SearchProductTypePreference? searchPreference,
    bool? isContinuousScanEnabledInInventory,
  }) {
    return AppSettingsModel(
      searchPreference: searchPreference ?? this.searchPreference,
      isContinuousScanEnabledInInventory:
          isContinuousScanEnabledInInventory ??
          this.isContinuousScanEnabledInInventory,
    );
  }
}
