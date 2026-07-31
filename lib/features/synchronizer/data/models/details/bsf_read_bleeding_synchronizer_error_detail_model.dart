import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

class BSFReadBleedingSynchronizerErrorDetailModel
    extends BSFReadBleedingSynchronizerErrorDetailEntity {
  const BSFReadBleedingSynchronizerErrorDetailModel({
    required super.enterprisePersonalizedCode,
    required super.creationDate,
    required super.movementDate,
    required super.cashierNumber,
    required super.description,
  });

  factory BSFReadBleedingSynchronizerErrorDetailModel.fromJson(Map json) =>
      BSFReadBleedingSynchronizerErrorDetailModel(
        enterprisePersonalizedCode:
            json['enterprisePersonalizedCode'] as String,
        creationDate: DateTime.parse(json['creationDate'] as String),
        movementDate: DateTime.parse(json['movementDate'] as String),
        cashierNumber: json['cashierNumber'] as String,
        description: json['description'] as String,
      );

  Map toJson() => {
    'enterprisePersonalizedCode': enterprisePersonalizedCode,
    'creationDate': creationDate.toIso8601String(),
    'movementDate': movementDate.toIso8601String(),
    'cashierNumber': cashierNumber,
    'description': description,
  };

  factory BSFReadBleedingSynchronizerErrorDetailModel.fromEntity(
    BSFReadBleedingSynchronizerErrorDetailEntity entity,
  ) => BSFReadBleedingSynchronizerErrorDetailModel(
    enterprisePersonalizedCode: entity.enterprisePersonalizedCode,
    creationDate: entity.creationDate,
    movementDate: entity.movementDate,
    cashierNumber: entity.cashierNumber,
    description: entity.description,
  );

  BSFReadBleedingSynchronizerErrorDetailEntity toEntity() =>
      BSFReadBleedingSynchronizerErrorDetailEntity(
        enterprisePersonalizedCode: enterprisePersonalizedCode,
        creationDate: creationDate,
        movementDate: movementDate,
        cashierNumber: cashierNumber,
        description: description,
      );
}
