import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

class BSFCorrespondentBankingSynchronizerErrorDetailModel
    extends BSFCorrespondentBankingSynchronizerErrorDetailEntity {
  const BSFCorrespondentBankingSynchronizerErrorDetailModel({
    required super.enterprisePersonalizedCode,
    required super.creationDate,
    required super.deliveryDate,
    required super.correspondentBankingNumber,
    required super.ecfNumber,
    required super.cashRegisterNumber,
    required super.details,
  });

  factory BSFCorrespondentBankingSynchronizerErrorDetailModel.fromJson(
    Map json,
  ) => BSFCorrespondentBankingSynchronizerErrorDetailModel(
    enterprisePersonalizedCode: json['EnterprisePersonalizedCode'] as String,
    creationDate: DateTime.parse(json['CreationDate'] as String),
    deliveryDate: DateTime.parse(json['DeliveryDate'] as String),
    correspondentBankingNumber: json['CorrespondentBankingNumber'] as String,
    ecfNumber: json['EcfNumber'] as String,
    cashRegisterNumber: json['CashRegisterNumber'] as String,
    details: List<String>.from(json['Details'] as List),
  );

  Map toJson() => {
    'EnterprisePersonalizedCode': enterprisePersonalizedCode,
    'CreationDate': creationDate.toIso8601String(),
    'DeliveryDate': deliveryDate.toIso8601String(),
    'CorrespondentBankingNumber': correspondentBankingNumber,
    'EcfNumber': ecfNumber,
    'CashRegisterNumber': cashRegisterNumber,
    'Details': details,
  };

  factory BSFCorrespondentBankingSynchronizerErrorDetailModel.fromEntity(
    BSFCorrespondentBankingSynchronizerErrorDetailEntity entity,
  ) => BSFCorrespondentBankingSynchronizerErrorDetailModel(
    enterprisePersonalizedCode: entity.enterprisePersonalizedCode,
    creationDate: entity.creationDate,
    deliveryDate: entity.deliveryDate,
    correspondentBankingNumber: entity.correspondentBankingNumber,
    ecfNumber: entity.ecfNumber,
    cashRegisterNumber: entity.cashRegisterNumber,
    details: entity.details,
  );

  BSFCorrespondentBankingSynchronizerErrorDetailEntity toEntity() =>
      BSFCorrespondentBankingSynchronizerErrorDetailEntity(
        enterprisePersonalizedCode: enterprisePersonalizedCode,
        creationDate: creationDate,
        deliveryDate: deliveryDate,
        correspondentBankingNumber: correspondentBankingNumber,
        ecfNumber: ecfNumber,
        cashRegisterNumber: cashRegisterNumber,
        details: details,
      );
}
