import 'package:equatable/equatable.dart';

class EcBuyRequestEnterpriseDtoEntity extends Equatable {
  final String? personalizedCode;
  final String? cnpjNumber;
  final String? name;
  final int? code;

  const EcBuyRequestEnterpriseDtoEntity({
    required this.personalizedCode,
    required this.cnpjNumber,
    required this.name,
    required this.code,
  });

  @override
  List<Object?> get props => [personalizedCode, cnpjNumber, name, code];
}
