import 'package:equatable/equatable.dart';

import '../../../domain/entities/enterprise/bsf_enterprise_entity.dart';

class BSFEnterpriseModel extends Equatable {
  final int? code;
  final int? fiscalType;
  final int? federalSimpleType;
  final String? personalizedCode;
  final dynamic nationalSimple;
  final dynamic accountTreasury;
  final String? cnpjNumber;
  final String? suframaCode;
  final String? name;
  final String? fantasizesName;
  final String? contactName;

  const BSFEnterpriseModel({
    required this.code,
    required this.fiscalType,
    required this.federalSimpleType,
    required this.personalizedCode,
    required this.nationalSimple,
    required this.accountTreasury,
    required this.cnpjNumber,
    required this.suframaCode,
    required this.name,
    required this.fantasizesName,
    required this.contactName,
  });

  @override
  List<Object?> get props => [
    code,
    fiscalType,
    federalSimpleType,
    personalizedCode,
    nationalSimple,
    accountTreasury,
    cnpjNumber,
    suframaCode,
    name,
    fantasizesName,
    contactName,
  ];

  factory BSFEnterpriseModel.fromJson(Map json) => BSFEnterpriseModel(
    code: json['Code'],
    fiscalType: json['FiscalType'],
    federalSimpleType: json['FederalSimpleType'],
    personalizedCode: json['PersonalizedCode'],
    nationalSimple: json['NationalSimple'],
    accountTreasury: json['AccountTreasury'],
    cnpjNumber: json['CnpjNumber'],
    suframaCode: json['SuframaCode'],
    name: json['Name'],
    fantasizesName: json['FantasizesName'],
    contactName: json['ContactName'],
  );

  Map<String, dynamic> toJson() => {
    'Code': code,
    'FiscalType': fiscalType,
    'FederalSimpleType': federalSimpleType,
    'PersonalizedCode': personalizedCode,
    'NationalSimple': nationalSimple,
    'AccountTreasury': accountTreasury,
    'CnpjNumber': cnpjNumber,
    'SuframaCode': suframaCode,
    'Name': name,
    'FantasizesName': fantasizesName,
    'ContactName': contactName,
  };

  factory BSFEnterpriseModel.fromEntity(BSFEnterpriseEntity entity) =>
      BSFEnterpriseModel(
        code: entity.code,
        fiscalType: entity.fiscalType,
        federalSimpleType: entity.federalSimpleType,
        personalizedCode: entity.personalizedCode,
        nationalSimple: entity.nationalSimple,
        accountTreasury: entity.accountTreasury,
        cnpjNumber: entity.cnpjNumber,
        suframaCode: entity.suframaCode,
        name: entity.name,
        fantasizesName: entity.fantasizesName,
        contactName: entity.contactName,
      );

  BSFEnterpriseEntity toEntity() => BSFEnterpriseEntity(
    code: code,
    fiscalType: fiscalType,
    federalSimpleType: federalSimpleType,
    personalizedCode: personalizedCode,
    nationalSimple: nationalSimple,
    accountTreasury: accountTreasury,
    cnpjNumber: cnpjNumber,
    suframaCode: suframaCode,
    name: name,
    fantasizesName: fantasizesName,
    contactName: contactName,
  );
}
