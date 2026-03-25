import 'package:equatable/equatable.dart';

import 'ec_complete.dart';

class EcCompleteFreightModel extends Equatable {
  final double? value;
  final double? freightValueProrated;
  final double? security;
  final EcCompleteValueTypeModel? discount;
  final EcCompleteValueTypeModel? increment;
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

  const EcCompleteFreightModel({
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

  factory EcCompleteFreightModel.fromJson(Map<String, dynamic> json) =>
      EcCompleteFreightModel(
        value: (json['Value'] as num?)?.toDouble(),
        freightValueProrated: (json['FreightValueProrated'] as num?)
            ?.toDouble(),
        security: (json['Security'] as num?)?.toDouble(),
        discount: json['Discount'] != null
            ? EcCompleteValueTypeModel.fromJson(json['Discount'])
            : null,
        increment: json['Increment'] != null
            ? EcCompleteValueTypeModel.fromJson(json['Increment'])
            : null,
        type: json['Type'],
        icmsAliquot: (json['IcmsAliquot'] as num?)?.toDouble(),
        irrf: (json['Irrf'] as num?)?.toDouble(),
        inss: (json['Inss'] as num?)?.toDouble(),
        icmsRetainByDestiny: json['IcmsRetainByDestiny'],
        code: json['Code'],
        documentNumber: json['DocumentNumber'],
        documentNumberComplement: json['DocumentNumberComplement'],
        eletronicAccessKey: json['EletronicAccessKey'],
        dateOfEmission: json['DateOfEmission'] != null
            ? DateTime.parse(json['DateOfEmission'])
            : null,
        dateOfEntrance: json['DateOfEntrance'] != null
            ? DateTime.parse(json['DateOfEntrance'])
            : null,
      );

  Map<String, dynamic> toJson() => {
    'Value': value,
    'FreightValueProrated': freightValueProrated,
    'Security': security,
    'Discount': discount?.toJson(),
    'Increment': increment?.toJson(),
    'Type': type,
    'IcmsAliquot': icmsAliquot,
    'Irrf': irrf,
    'Inss': inss,
    'IcmsRetainByDestiny': icmsRetainByDestiny,
    'Code': code,
    'DocumentNumber': documentNumber,
    'DocumentNumberComplement': documentNumberComplement,
    'EletronicAccessKey': eletronicAccessKey,
    'DateOfEmission': dateOfEmission?.toIso8601String(),
    'DateOfEntrance': dateOfEntrance?.toIso8601String(),
  };

  @override
  List<Object?> get props => [value, type, code];
}
