import 'Package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

class EcCashierMovementSynchronizerErrorDetailModel
    extends EcCashierMovementSynchronizerErrorDetailEntity {
  const EcCashierMovementSynchronizerErrorDetailModel({
    required super.enterprisePersonalizedCode,
    required super.creationDate,
    required super.openOrCloseDate,
    required super.cashRegisterPersonalizedCode,
    required super.code,
    required super.description,
  });

  factory EcCashierMovementSynchronizerErrorDetailModel.fromJson(Map json) =>
      EcCashierMovementSynchronizerErrorDetailModel(
        enterprisePersonalizedCode:
            json['EnterprisePersonalizedCode'] as String,
        creationDate: DateTime.parse(json['CreationDate'] as String),
        openOrCloseDate: DateTime.parse(json['OpenOrCloseDate'] as String),
        cashRegisterPersonalizedCode:
            json['CashRegisterPersonalizedCode'] as String,
        code: json['Code'] as int,
        description: json['Description'] as String,
      );

  Map toJson() => {
    'EnterprisePersonalizedCode': enterprisePersonalizedCode,
    'CreationDate': creationDate.toIso8601String(),
    'OpenOrCloseDate': openOrCloseDate.toIso8601String(),
    'CashRegisterPersonalizedCode': cashRegisterPersonalizedCode,
    'Code': code,
    'Description': description,
  };

  factory EcCashierMovementSynchronizerErrorDetailModel.fromEntity(
    EcCashierMovementSynchronizerErrorDetailEntity entity,
  ) => EcCashierMovementSynchronizerErrorDetailModel(
    enterprisePersonalizedCode: entity.enterprisePersonalizedCode,
    creationDate: entity.creationDate,
    openOrCloseDate: entity.openOrCloseDate,
    cashRegisterPersonalizedCode: entity.cashRegisterPersonalizedCode,
    code: entity.code,
    description: entity.description,
  );

  EcCashierMovementSynchronizerErrorDetailEntity toEntity() =>
      EcCashierMovementSynchronizerErrorDetailEntity(
        enterprisePersonalizedCode: enterprisePersonalizedCode,
        creationDate: creationDate,
        openOrCloseDate: openOrCloseDate,
        cashRegisterPersonalizedCode: cashRegisterPersonalizedCode,
        code: code,
        description: description,
      );
}
