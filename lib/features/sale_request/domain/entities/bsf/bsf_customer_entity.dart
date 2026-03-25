import 'package:equatable/equatable.dart';

class BSFCustomerEntity extends Equatable {
  final String? personalizedCode;
  final String? name;
  final String? nameReduced;
  final String? cnpjCpfNumber;
  final String? suframaCode;
  final double? limitOfPurchase;
  final String? inscriptionRgNumber;

  const BSFCustomerEntity({
    required this.personalizedCode,
    required this.name,
    required this.nameReduced,
    required this.cnpjCpfNumber,
    required this.suframaCode,
    required this.limitOfPurchase,
    required this.inscriptionRgNumber,
  });

  @override
  List<Object?> get props => [cnpjCpfNumber, name];
}
