import 'Package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

class BSFReadBleedingSynchronizerErrorDetailModel
    extends BSFReadBleedingSynchronizerErrorDetailEntity {
  const BSFReadBleedingSynchronizerErrorDetailModel({
    required super.code,
    required super.enterprisePersonalizedCode,
    required super.creationDate,
    required super.movementDate,
    required super.cashierNumber,
    required super.description,
  });

  factory BSFReadBleedingSynchronizerErrorDetailModel.fromJson(Map json) =>
      BSFReadBleedingSynchronizerErrorDetailModel(
        code: json['Code'],
        enterprisePersonalizedCode:
            json['EnterprisePersonalizedCode'] as String,
        creationDate: DateTime.parse(json['CreationDate'] as String),
        movementDate: DateTime.parse(json['MovementDate'] as String),
        cashierNumber: json['CashierNumber'] as String,
        description: json['Description'] as String,
      );

  Map toJson() => {
    'Code': code,
    'EnterprisePersonalizedCode': enterprisePersonalizedCode,
    'CreationDate': creationDate.toIso8601String(),
    'MovementDate': movementDate.toIso8601String(),
    'CashierNumber': cashierNumber,
    'Description': description,
  };

  factory BSFReadBleedingSynchronizerErrorDetailModel.fromEntity(
    BSFReadBleedingSynchronizerErrorDetailEntity entity,
  ) => BSFReadBleedingSynchronizerErrorDetailModel(
    code: entity.code,
    enterprisePersonalizedCode: entity.enterprisePersonalizedCode,
    creationDate: entity.creationDate,
    movementDate: entity.movementDate,
    cashierNumber: entity.cashierNumber,
    description: entity.description,
  );

  BSFReadBleedingSynchronizerErrorDetailEntity toEntity() =>
      BSFReadBleedingSynchronizerErrorDetailEntity(
        code: code,
        enterprisePersonalizedCode: enterprisePersonalizedCode,
        creationDate: creationDate,
        movementDate: movementDate,
        cashierNumber: cashierNumber,
        description: description,
      );
}
