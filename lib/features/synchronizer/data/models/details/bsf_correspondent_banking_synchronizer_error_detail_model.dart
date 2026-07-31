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
    enterprisePersonalizedCode: json['enterprisePersonalizedCode'] as String,
    creationDate: DateTime.parse(json['creationDate'] as String),
    deliveryDate: DateTime.parse(json['deliveryDate'] as String),
    correspondentBankingNumber: json['correspondentBankingNumber'] as String,
    ecfNumber: json['ecfNumber'] as String,
    cashRegisterNumber: json['cashRegisterNumber'] as String,
    details: List<String>.from(json['details'] as List),
  );

  Map toJson() => {
    'enterprisePersonalizedCode': enterprisePersonalizedCode,
    'creationDate': creationDate.toIso8601String(),
    'deliveryDate': deliveryDate.toIso8601String(),
    'correspondentBankingNumber': correspondentBankingNumber,
    'ecfNumber': ecfNumber,
    'cashRegisterNumber': cashRegisterNumber,
    'details': details,
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
