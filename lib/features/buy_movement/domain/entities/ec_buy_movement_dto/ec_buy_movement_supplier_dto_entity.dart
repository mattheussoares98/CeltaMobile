import 'package:equatable/equatable.dart';

class EcBuyMovementSupplierDtoEntity extends Equatable {
  final int? code;
  final String? name;
  final String? fantasizesName;
  final String? suframaCode;
  final String? cnpjCpfNumber;
  final String? formatedCnpjCpfNumber;
  final String? inscriptionRgNumber;

  const EcBuyMovementSupplierDtoEntity({
    required this.code,
    required this.name,
    required this.fantasizesName,
    required this.suframaCode,
    required this.cnpjCpfNumber,
    required this.formatedCnpjCpfNumber,
    required this.inscriptionRgNumber,
  });

  @override
  List<Object?> get props => [
    code,
    name,
    fantasizesName,
    suframaCode,
    cnpjCpfNumber,
    formatedCnpjCpfNumber,
    inscriptionRgNumber,
  ];
}
