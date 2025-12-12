import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';

class BuyQuotationEnterpriseInfoModel extends Equatable {
  final String? PersonalizedCode;
  final String? Name;
  final String? CnpjNumber;
  final String? InscriptionNumber;
  final int? Code;

  const BuyQuotationEnterpriseInfoModel({
    required this.PersonalizedCode,
    required this.Name,
    required this.CnpjNumber,
    required this.InscriptionNumber,
    required this.Code,
  });

  @override
  List<Object?> get props => [
    PersonalizedCode,
    Name,
    CnpjNumber,
    InscriptionNumber,
    Code,
  ];

  factory BuyQuotationEnterpriseInfoModel.fromJson(Map json) =>
      BuyQuotationEnterpriseInfoModel(
        PersonalizedCode: json['PersonalizedCode'],
        Name: json['Name'],
        CnpjNumber: json['CnpjNumber'],
        InscriptionNumber: json['InscriptionNumber'],
        Code: json['Code'],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'PersonalizedCode': PersonalizedCode,
    'Name': Name,
    'CnpjNumber': CnpjNumber,
    'InscriptionNumber': InscriptionNumber,
    'Code': Code,
  };

  factory BuyQuotationEnterpriseInfoModel.fromEntity(
    BuyQuotationEnterpriseInfoEntity entity,
  ) => BuyQuotationEnterpriseInfoModel(
    PersonalizedCode: entity.PersonalizedCode,
    Name: entity.Name,
    CnpjNumber: entity.CnpjNumber,
    InscriptionNumber: entity.InscriptionNumber,
    Code: entity.Code,
  );

  BuyQuotationEnterpriseInfoEntity toEntity() =>
      BuyQuotationEnterpriseInfoEntity(
        PersonalizedCode: PersonalizedCode,
        Name: Name,
        CnpjNumber: CnpjNumber,
        InscriptionNumber: InscriptionNumber,
        Code: Code,
      );
}
