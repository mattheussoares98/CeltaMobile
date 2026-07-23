import 'package:equatable/equatable.dart';

class EcBuyMovementEnterpriseDtoEntity extends Equatable {
  final String? personalizedCode;
  final String? cnpjNumber;
  final String? name;
  final int? code;

  const EcBuyMovementEnterpriseDtoEntity({
    required this.personalizedCode,
    required this.cnpjNumber,
    required this.name,
    required this.code,
  });

  @override
  List<Object?> get props => [personalizedCode, cnpjNumber, name, code];
}
