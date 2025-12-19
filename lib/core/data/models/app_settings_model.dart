// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';

class AppSettingsModel extends Equatable {
  final SearchProductTypePreference searchPreference;
  final bool? inventoryUseContinuousScan;
  final bool? expeditionUseContinuousScan;

  const AppSettingsModel({
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

  factory AppSettingsModel.fromJson(Map json) {
    return AppSettingsModel(
      searchPreference: SearchProductTypePreference.values.firstWhere(
        (element) => element.name == json['searchPreference'],
      ),
      inventoryUseContinuousScan: json['inventoryUseContinuousScan'],
      expeditionUseContinuousScan: json['expeditionUseContinuousScan'],
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'searchPreference': searchPreference.name,
    'inventoryUseContinuousScan': inventoryUseContinuousScan,
    'expeditionUseContinuousScan': expeditionUseContinuousScan,
  };

  AppSettingsEntity toEntity() => AppSettingsEntity(
    searchPreference: searchPreference,
    inventoryUseContinuousScan: inventoryUseContinuousScan,
    expeditionUseContinuousScan: expeditionUseContinuousScan,
  );

  factory AppSettingsModel.fromEntity(AppSettingsEntity entity) {
    return AppSettingsModel(
      searchPreference: entity.searchPreference,
      inventoryUseContinuousScan: entity.inventoryUseContinuousScan,
      expeditionUseContinuousScan: entity.expeditionUseContinuousScan,
    );
  }

  AppSettingsModel copyWith({
    SearchProductTypePreference? searchPreference,
    bool? inventoryUseContinuousScan,
    bool? expeditionUseContinuousScan,
  }) {
    return AppSettingsModel(
      searchPreference: searchPreference ?? this.searchPreference,
      inventoryUseContinuousScan:
          inventoryUseContinuousScan ?? this.inventoryUseContinuousScan,
      expeditionUseContinuousScan:
          expeditionUseContinuousScan ?? this.expeditionUseContinuousScan,
    );
  }
}
