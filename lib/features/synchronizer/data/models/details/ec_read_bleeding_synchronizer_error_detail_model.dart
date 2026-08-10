import 'Package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

class EcReadBleedingSynchronizerErrorDetailModel
    extends EcReadBleedingSynchronizerErrorDetailEntity {
  const EcReadBleedingSynchronizerErrorDetailModel({
    required super.code,
    required super.enterprisePersonalizedCode,
    required super.creationDate,
    required super.movementDate,
    required super.cashierNumber,
    required super.description,
    required super.markedToReadAgain,
  });

  factory EcReadBleedingSynchronizerErrorDetailModel.fromJson(Map json) =>
      EcReadBleedingSynchronizerErrorDetailModel(
        code: json['Code'],
        enterprisePersonalizedCode:
            json['EnterprisePersonalizedCode'] as String,
        creationDate: DateTime.parse(json['CreationDate'] as String),
        movementDate: DateTime.parse(json['MovementDate'] as String),
        cashierNumber: json['CashierNumber'] as String,
        description: json['Description'] as String,
        markedToReadAgain: json['MarkedToReadAgain'] as bool,
      );

  Map toJson() => {
    'Code': code,
    'EnterprisePersonalizedCode': enterprisePersonalizedCode,
    'CreationDate': creationDate.toIso8601String(),
    'MovementDate': movementDate.toIso8601String(),
    'CashierNumber': cashierNumber,
    'Description': description,
    'MmarkedToReadAgain': markedToReadAgain,
  };

  factory EcReadBleedingSynchronizerErrorDetailModel.fromEntity(
    EcReadBleedingSynchronizerErrorDetailEntity entity,
  ) => EcReadBleedingSynchronizerErrorDetailModel(
    code: entity.code,
    enterprisePersonalizedCode: entity.enterprisePersonalizedCode,
    creationDate: entity.creationDate,
    movementDate: entity.movementDate,
    cashierNumber: entity.cashierNumber,
    description: entity.description,
    markedToReadAgain: entity.markedToReadAgain,
  );

  EcReadBleedingSynchronizerErrorDetailEntity toEntity() =>
      EcReadBleedingSynchronizerErrorDetailEntity(
        code: code,
        enterprisePersonalizedCode: enterprisePersonalizedCode,
        creationDate: creationDate,
        movementDate: movementDate,
        cashierNumber: cashierNumber,
        description: description,
        markedToReadAgain: markedToReadAgain,
      );
}
