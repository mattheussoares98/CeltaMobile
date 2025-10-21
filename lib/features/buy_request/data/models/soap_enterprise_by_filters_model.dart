import 'package:equatable/equatable.dart';

import '../../../../core/domain/entities/entities.dart';

class SoapEnterpriseByFiltersModel extends Equatable {
  final int? Code;
  final int? SaleRequestTypeCode;
  final String? PersonalizedCode;
  final String? Name;
  final String? FantasizesName;
  final String? CnpjNumber;
  final String? InscriptionNumber;

  const SoapEnterpriseByFiltersModel({
    required this.Code,
    required this.SaleRequestTypeCode,
    required this.PersonalizedCode,
    required this.Name,
    required this.FantasizesName,
    required this.CnpjNumber,
    required this.InscriptionNumber,
  });

  @override
  List<Object?> get props => [
    Code,
    SaleRequestTypeCode,
    PersonalizedCode,
    Name,
    FantasizesName,
    CnpjNumber,
    InscriptionNumber,
  ];

  factory SoapEnterpriseByFiltersModel.fromJson(Map json) =>
      SoapEnterpriseByFiltersModel(
        Code: json["Code"],
        SaleRequestTypeCode: json["SaleRequestTypeCode"],
        PersonalizedCode: json["PersonalizedCode"],
        Name: json["Name"],
        FantasizesName: json["FantasizesName"],
        CnpjNumber: json["CnpjNumber"],
        InscriptionNumber: json["InscriptionNumber"],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
    "Code": Code,
    "SaleRequestTypeCode": SaleRequestTypeCode,
    "PersonalizedCode": PersonalizedCode,
    "Name": Name,
    "FantasizesName": FantasizesName,
    "CnpjNumber": CnpjNumber,
    "InscriptionNumber": InscriptionNumber,
  };

  factory SoapEnterpriseByFiltersModel.fromEntity(EnterpriseEntity entity) =>
      SoapEnterpriseByFiltersModel(
        Code: entity.Code,
        SaleRequestTypeCode: entity.SaleRequestTypeCode,
        PersonalizedCode: entity.PersonalizedCode,
        Name: entity.name,
        FantasizesName: entity.FantasizesName,
        CnpjNumber: entity.CnpjNumber,
        InscriptionNumber: entity.InscriptionNumber,
      );

  EnterpriseEntity toEntity() => EnterpriseEntity(
    name: Name ?? '',
    SaleRequestTypeCode: SaleRequestTypeCode,
    PersonalizedCode: PersonalizedCode,
    FantasizesName: FantasizesName,
    CnpjNumber: CnpjNumber,
    InscriptionNumber: InscriptionNumber,
  );
}
