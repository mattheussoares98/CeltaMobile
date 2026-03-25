import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';
import 'bsf.dart';

class BSFFreightModel extends Equatable {
  final double? value;
  final double? freightValueProrated;
  final double? security;
  final BSFValueTypeModel? discount;
  final BSFValueTypeModel? increment;
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

  const BSFFreightModel({
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

  factory BSFFreightModel.fromJson(Map<String, dynamic> json) =>
      BSFFreightModel(
        value: (json['Value'] as num?)?.toDouble(),
        freightValueProrated: (json['FreightValueProrated'] as num?)
            ?.toDouble(),
        security: (json['Security'] as num?)?.toDouble(),
        discount: json['Discount'] != null
            ? BSFValueTypeModel.fromJson(json['Discount'])
            : null,
        increment: json['Increment'] != null
            ? BSFValueTypeModel.fromJson(json['Increment'])
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

  factory BSFFreightModel.fromEntity(BSFFreightEntity entity) =>
      BSFFreightModel(
        value: entity.value,
        freightValueProrated: entity.freightValueProrated,
        security: entity.security,
        discount: entity.discount == null
            ? null
            : BSFValueTypeModel.fromEntity(entity.discount!),
        increment: entity.increment == null
            ? null
            : BSFValueTypeModel.fromEntity(entity.increment!),
        type: entity.type,
        icmsAliquot: entity.icmsAliquot,
        irrf: entity.irrf,
        inss: entity.inss,
        icmsRetainByDestiny: entity.icmsRetainByDestiny,
        code: entity.code,
        documentNumber: entity.documentNumber,
        documentNumberComplement: entity.documentNumberComplement,
        eletronicAccessKey: entity.eletronicAccessKey,
        dateOfEmission: entity.dateOfEmission,
        dateOfEntrance: entity.dateOfEntrance,
      );

  BSFFreightEntity toEntity() => BSFFreightEntity(
    value: value,
    freightValueProrated: freightValueProrated,
    security: security,
    discount: discount?.toEntity(),
    increment: increment?.toEntity(),
    type: type,
    icmsAliquot: icmsAliquot,
    irrf: irrf,
    inss: inss,
    icmsRetainByDestiny: icmsRetainByDestiny,
    code: code,
    documentNumber: documentNumber,
    documentNumberComplement: documentNumberComplement,
    eletronicAccessKey: eletronicAccessKey,
    dateOfEmission: dateOfEmission,
    dateOfEntrance: dateOfEntrance,
  );
}
