import 'package:equatable/equatable.dart';

class BSFCustomerModel extends Equatable {
  final String? personalizedCode;
  final String? name;
  final String? nameReduced;
  final String? cnpjCpfNumber;
  final String? suframaCode;
  final double? limitOfPurchase;
  final String? inscriptionRgNumber;

  const BSFCustomerModel({
    required this.personalizedCode,
    required this.name,
    required this.nameReduced,
    required this.cnpjCpfNumber,
    required this.suframaCode,
    required this.limitOfPurchase,
    required this.inscriptionRgNumber,
  });

  factory BSFCustomerModel.fromJson(Map<String, dynamic> json) =>
      BSFCustomerModel(
        personalizedCode: json['PersonalizedCode'],
        name: json['Name'],
        nameReduced: json['NameReduced'],
        cnpjCpfNumber: json['CnpjCpfNumber'],
        suframaCode: json['SuframaCode'],
        limitOfPurchase: (json['LimitOfPurchase'] as num?)?.toDouble(),
        inscriptionRgNumber: json['InscriptionRgNumber'],
      );

  Map<String, dynamic> toJson() => {
    'PersonalizedCode': personalizedCode,
    'Name': name,
    'NameReduced': nameReduced,
    'CnpjCpfNumber': cnpjCpfNumber,
    'SuframaCode': suframaCode,
    'LimitOfPurchase': limitOfPurchase,
    'InscriptionRgNumber': inscriptionRgNumber,
  };

  @override
  List<Object?> get props => [cnpjCpfNumber, name];
}
