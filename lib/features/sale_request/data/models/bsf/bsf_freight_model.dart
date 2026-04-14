import '../../../domain/entities/entities.dart';
import 'bsf.dart';

class BSFFreightModel extends BSFFreightEntity {
  const BSFFreightModel({
    required super.value,
    required super.freightValueProrated,
    required super.security,
    required super.discount,
    required super.increment,
    required super.type,
    required super.icmsAliquot,
    required super.irrf,
    required super.inss,
    required super.icmsRetainByDestiny,
    required super.code,
    required super.documentNumber,
    required super.documentNumberComplement,
    required super.eletronicAccessKey,
    required super.dateOfEmission,
    required super.dateOfEntrance,
  });

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
    'Discount': discount,
    'Increment': increment,
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
        discount: entity.discount as BSFValueTypeModel?,
        increment: entity.increment as BSFValueTypeModel?,
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
    discount: discount,
    increment: increment,
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
