import '../../../../../../../core/domain/entities/entities.dart';

class UtilizationParametersModel extends UtilizationParametersEntity {
  const UtilizationParametersModel({
    required super.isShielded,
    required super.baseDate,
    required super.valueParcel,
  });

  factory UtilizationParametersModel.fromJson(Map<String, dynamic> json) =>
      UtilizationParametersModel(
        isShielded: json['IsShielded'] ?? false,
        baseDate: json['BaseDate'] != null
            ? DateTime.parse(json['BaseDate'])
            : DateTime.now(),
        valueParcel: (json['ValueParcel'] as num?)?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
    'IsShielded': isShielded,
    'BaseDate': baseDate.toIso8601String(),
    'ValueParcel': valueParcel,
  };

  factory UtilizationParametersModel.fromEntity(
    UtilizationParametersEntity entity,
  ) => UtilizationParametersModel(
    isShielded: entity.isShielded,
    baseDate: entity.baseDate,
    valueParcel: entity.valueParcel,
  );

  UtilizationParametersEntity toEntity() => UtilizationParametersEntity(
    isShielded: isShielded,
    baseDate: baseDate,
    valueParcel: valueParcel,
  );
}
