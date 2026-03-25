import 'package:equatable/equatable.dart';

class BSFEnterpriseEntity extends Equatable {
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

  const BSFEnterpriseEntity({
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
  List<Object?> get props => [code, cnpjNumber, name];
}
