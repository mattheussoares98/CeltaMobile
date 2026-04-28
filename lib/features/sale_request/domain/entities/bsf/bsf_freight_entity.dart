import 'package:equatable/equatable.dart';

import 'bsf.dart';

class BSFFreightEntity extends Equatable {
  final double? value;
  final double? freightValueProrated;
  final double? security;
  final BSFValueTypeEntity? discount;
  final BSFValueTypeEntity? increment;
  final int? type;
  final double? icmsAliquot;
  final double? irrf;
  final double? inss;
  final bool? icmsRetainByDestiny;
  final int? code;
  final int? documentNumber;
  final String? documentNumberComplement;
  final Map<String, dynamic>? eletronicAccessKey;
  final DateTime? dateOfEmission;
  final DateTime? dateOfEntrance;

  const BSFFreightEntity({
    required this.value,
    required this.freightValueProrated,
    required this.security,
    required this.discount,
    required this.increment,
    required this.type,
    required this.icmsAliquot,
    required this.irrf,
    required this.inss,
    required this.icmsRetainByDestiny,
    required this.code,
    required this.documentNumber,
    required this.documentNumberComplement,
    required this.eletronicAccessKey,
    required this.dateOfEmission,
    required this.dateOfEntrance,
  });

  @override
  List<Object?> get props => [
    value,
    freightValueProrated,
    security,
    discount,
    increment,
    type,
    icmsAliquot,
    irrf,
    inss,
    icmsRetainByDestiny,
    code,
    documentNumber,
    documentNumberComplement,
    eletronicAccessKey,
    dateOfEmission,
    dateOfEntrance,
  ];
}
