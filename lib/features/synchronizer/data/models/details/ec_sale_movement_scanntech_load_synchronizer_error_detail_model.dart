import 'Package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

class EcSaleMovementScanntechLoadSynchronizerErrorDetailModel
    extends EcSaleMovementScanntechLoadSynchronizerErrorDetailEntity {
  const EcSaleMovementScanntechLoadSynchronizerErrorDetailModel({
    required super.enterprisePersonalizedCode,
    required super.creationDate,
    required super.billingDate,
    required super.cashierNumber,
    required super.ecfNumber,
    required super.documentNumber,
    required super.description,
  });

  factory EcSaleMovementScanntechLoadSynchronizerErrorDetailModel.fromJson(
    Map json,
  ) => EcSaleMovementScanntechLoadSynchronizerErrorDetailModel(
    enterprisePersonalizedCode: json['EnterprisePersonalizedCode'] as String,
    creationDate: DateTime.parse(json['CreationDate'] as String),
    billingDate: DateTime.parse(json['billingDate'] as String),
    cashierNumber: json['CashierNumber'] as String,
    ecfNumber: json['EcfNumber'] as String,
    documentNumber: json['DocumentNumber'] as String,
    description: json['Description'] as String,
  );

  Map toJson() => {
    'EnterprisePersonalizedCode': enterprisePersonalizedCode,
    'CreationDate': creationDate.toIso8601String(),
    'billingDate': billingDate.toIso8601String(),
    'CashierNumber': cashierNumber,
    'EcfNumber': ecfNumber,
    'DocumentNumber': documentNumber,
    'Description': description,
  };

  factory EcSaleMovementScanntechLoadSynchronizerErrorDetailModel.fromEntity(
    EcSaleMovementScanntechLoadSynchronizerErrorDetailEntity entity,
  ) => EcSaleMovementScanntechLoadSynchronizerErrorDetailModel(
    enterprisePersonalizedCode: entity.enterprisePersonalizedCode,
    creationDate: entity.creationDate,
    billingDate: entity.billingDate,
    cashierNumber: entity.cashierNumber,
    ecfNumber: entity.ecfNumber,
    documentNumber: entity.documentNumber,
    description: entity.description,
  );

  EcSaleMovementScanntechLoadSynchronizerErrorDetailEntity toEntity() =>
      EcSaleMovementScanntechLoadSynchronizerErrorDetailEntity(
        enterprisePersonalizedCode: enterprisePersonalizedCode,
        creationDate: creationDate,
        billingDate: billingDate,
        cashierNumber: cashierNumber,
        ecfNumber: ecfNumber,
        documentNumber: documentNumber,
        description: description,
      );
}
