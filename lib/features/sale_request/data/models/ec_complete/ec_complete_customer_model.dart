import 'package:equatable/equatable.dart';

class EcCompleteCustomerModel extends Equatable {
  final String? personalizedCode;
  final String? name;
  final String? nameReduced;
  final String? cnpjCpfNumber;
  final String? suframaCode;
  final double? limitOfPurchase;
  final String? inscriptionRgNumber;

  const EcCompleteCustomerModel({
    required this.personalizedCode,
    required this.name,
    required this.nameReduced,
    required this.cnpjCpfNumber,
    required this.suframaCode,
    required this.limitOfPurchase,
    required this.inscriptionRgNumber,
  });

  factory EcCompleteCustomerModel.fromJson(Map<String, dynamic> json) =>
      EcCompleteCustomerModel(
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
