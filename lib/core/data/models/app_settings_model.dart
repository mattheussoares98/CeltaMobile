// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:celta_inventario/core/domain/entities/entities.dart';

class AppSettingsModel extends Equatable {
  final SearchProductTypePreference searchPreference;
  final bool? inventoryUseContinuousScan;
  final bool? expeditionUseContinuousScan;
  final bool? receiptUseContinuousScan;

  const AppSettingsModel({
    required this.searchPreference,
    required this.inventoryUseContinuousScan,
    required this.expeditionUseContinuousScan,
    required this.receiptUseContinuousScan,
  });

  @override
  List<Object?> get props => [
    searchPreference,
    inventoryUseContinuousScan,
    expeditionUseContinuousScan,
    receiptUseContinuousScan,
  ];

  factory AppSettingsModel.fromJson(Map json) {
    return AppSettingsModel(
      searchPreference: SearchProductTypePreference.values.firstWhere(
        (element) => element.name == json['searchPreference'],
      ),
      inventoryUseContinuousScan: json['inventoryUseContinuousScan'],
      expeditionUseContinuousScan: json['expeditionUseContinuousScan'],
      receiptUseContinuousScan: json['receiptUseContinuousScan'],
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'searchPreference': searchPreference.name,
    'inventoryUseContinuousScan': inventoryUseContinuousScan,
    'expeditionUseContinuousScan': expeditionUseContinuousScan,
    'receiptUseContinuousScan': receiptUseContinuousScan,
  };

  AppSettingsEntity toEntity() => AppSettingsEntity(
    searchPreference: searchPreference,
    inventoryUseContinuousScan: inventoryUseContinuousScan,
    expeditionUseContinuousScan: expeditionUseContinuousScan,
    receiptUseContinuousScan: receiptUseContinuousScan,
  );

  factory AppSettingsModel.fromEntity(AppSettingsEntity entity) {
    return AppSettingsModel(
      searchPreference: entity.searchPreference,
      inventoryUseContinuousScan: entity.inventoryUseContinuousScan,
      expeditionUseContinuousScan: entity.expeditionUseContinuousScan,
      receiptUseContinuousScan: entity.receiptUseContinuousScan,
    );
  }

  AppSettingsModel copyWith({
    SearchProductTypePreference? searchPreference,
    bool? inventoryUseContinuousScan,
    bool? expeditionUseContinuousScan,
    bool? receiptUseContinuousScan,
  }) {
    return AppSettingsModel(
      searchPreference: searchPreference ?? this.searchPreference,
      inventoryUseContinuousScan:
          inventoryUseContinuousScan ?? this.inventoryUseContinuousScan,
      expeditionUseContinuousScan:
          expeditionUseContinuousScan ?? this.expeditionUseContinuousScan,
      receiptUseContinuousScan:
          receiptUseContinuousScan ?? this.receiptUseContinuousScan,
    );
  }
}
