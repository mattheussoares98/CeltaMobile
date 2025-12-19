// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';

class AppSettingsModel extends Equatable {
  final SearchProductTypePreference searchPreference;
  final bool isContinuousScanEnabledInInventory;
  final bool isContinuousScanEnabledInExpedition;

  const AppSettingsModel({
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

  factory AppSettingsModel.fromJson(Map json) {
    return AppSettingsModel(
      searchPreference: SearchProductTypePreference.values.firstWhere(
        (element) => element.name == json['searchPreference'],
      ),
      isContinuousScanEnabledInInventory:
          json['isContinuousScanEnabledInInventory'],
      isContinuousScanEnabledInExpedition:
          json['isContinuousScanEnabledInExpedition'],
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'searchPreference': searchPreference.name,
    'isContinuousScanEnabledInInventory': isContinuousScanEnabledInInventory,
    'isContinuousScanEnabledInExpedition': isContinuousScanEnabledInExpedition,
  };

  AppSettingsEntity toEntity() => AppSettingsEntity(
    searchPreference: searchPreference,
    isContinuousScanEnabledInInventory: isContinuousScanEnabledInInventory,
    isContinuousScanEnabledInExpedition: isContinuousScanEnabledInExpedition,
  );

  factory AppSettingsModel.fromEntity(AppSettingsEntity entity) {
    return AppSettingsModel(
      searchPreference: entity.searchPreference,
      isContinuousScanEnabledInInventory:
          entity.isContinuousScanEnabledInInventory,
      isContinuousScanEnabledInExpedition:
          entity.isContinuousScanEnabledInExpedition,
    );
  }

  AppSettingsModel copyWith({
    SearchProductTypePreference? searchPreference,
    bool? isContinuousScanEnabledInInventory,
    bool? isContinuousScanEnabledInExpedition,
  }) {
    return AppSettingsModel(
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
