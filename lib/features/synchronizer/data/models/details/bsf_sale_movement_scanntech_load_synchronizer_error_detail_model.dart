import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

class BSFSaleMovementScanntechLoadSynchronizerErrorDetailModel
    extends BSFSaleMovementScanntechLoadSynchronizerErrorDetailEntity {
  const BSFSaleMovementScanntechLoadSynchronizerErrorDetailModel({
    required super.enterprisePersonalizedCode,
    required super.creationDate,
    required super.billingDate,
    required super.cashierNumber,
    required super.ecfNumber,
    required super.documentNumber,
    required super.description,
  });

  factory BSFSaleMovementScanntechLoadSynchronizerErrorDetailModel.fromJson(
    Map json,
  ) => BSFSaleMovementScanntechLoadSynchronizerErrorDetailModel(
    enterprisePersonalizedCode: json['enterprisePersonalizedCode'] as String,
    creationDate: DateTime.parse(json['creationDate'] as String),
    billingDate: DateTime.parse(json['billingDate'] as String),
    cashierNumber: json['cashierNumber'] as String,
    ecfNumber: json['ecfNumber'] as String,
    documentNumber: json['documentNumber'] as String,
    description: json['description'] as String,
  );

  Map toJson() => {
    'enterprisePersonalizedCode': enterprisePersonalizedCode,
    'creationDate': creationDate.toIso8601String(),
    'billingDate': billingDate.toIso8601String(),
    'cashierNumber': cashierNumber,
    'ecfNumber': ecfNumber,
    'documentNumber': documentNumber,
    'description': description,
  };

  factory BSFSaleMovementScanntechLoadSynchronizerErrorDetailModel.fromEntity(
    BSFSaleMovementScanntechLoadSynchronizerErrorDetailEntity entity,
  ) => BSFSaleMovementScanntechLoadSynchronizerErrorDetailModel(
    enterprisePersonalizedCode: entity.enterprisePersonalizedCode,
    creationDate: entity.creationDate,
    billingDate: entity.billingDate,
    cashierNumber: entity.cashierNumber,
    ecfNumber: entity.ecfNumber,
    documentNumber: entity.documentNumber,
    description: entity.description,
  );

  BSFSaleMovementScanntechLoadSynchronizerErrorDetailEntity toEntity() =>
      BSFSaleMovementScanntechLoadSynchronizerErrorDetailEntity(
        enterprisePersonalizedCode: enterprisePersonalizedCode,
        creationDate: creationDate,
        billingDate: billingDate,
        cashierNumber: cashierNumber,
        ecfNumber: ecfNumber,
        documentNumber: documentNumber,
        description: description,
      );
}
