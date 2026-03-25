import 'package:equatable/equatable.dart';

class EcCompleteEnterpriseModel extends Equatable {
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

  const EcCompleteEnterpriseModel({
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

  factory EcCompleteEnterpriseModel.fromJson(Map<String, dynamic> json) =>
      EcCompleteEnterpriseModel(
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

  @override
  List<Object?> get props => [code, cnpjNumber, name];
}
