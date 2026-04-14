import '../../../domain/entities/entities.dart';

class BSFCustomerModel extends BSFCustomerEntity {
  const BSFCustomerModel({
    required super.code,
    required super.personalizedCode,
    required super.name,
    required super.nameReduced,
    required super.cnpjCpfNumber,
    required super.suframaCode,
    required super.limitOfPurchase,
    required super.inscriptionRgNumber,
  });

  @override
  List<Object?> get props => [
    personalizedCode,
    name,
    nameReduced,
    cnpjCpfNumber,
    suframaCode,
    limitOfPurchase,
    inscriptionRgNumber,
  ];

  factory BSFCustomerModel.fromJson(Map<String, dynamic> json) =>
      BSFCustomerModel(
        code: json['Code'],
        personalizedCode: json['PersonalizedCode'],
        name: json['Name'],
        nameReduced: json['NameReduced'],
        cnpjCpfNumber: json['CnpjCpfNumber'],
        suframaCode: json['SuframaCode'],
        limitOfPurchase: (json['LimitOfPurchase'] as num?)?.toDouble(),
        inscriptionRgNumber: json['InscriptionRgNumber'],
      );

  Map<String, dynamic> toJson() => {
    'Code': code,
    'PersonalizedCode': personalizedCode,
    'Name': name,
    'NameReduced': nameReduced,
    'CnpjCpfNumber': cnpjCpfNumber,
    'SuframaCode': suframaCode,
    'LimitOfPurchase': limitOfPurchase,
    'InscriptionRgNumber': inscriptionRgNumber,
  };

  factory BSFCustomerModel.fromEntity(BSFCustomerEntity entity) =>
      BSFCustomerModel(
        code: entity.code,
        personalizedCode: entity.personalizedCode,
        name: entity.name,
        nameReduced: entity.nameReduced,
        cnpjCpfNumber: entity.cnpjCpfNumber,
        suframaCode: entity.suframaCode,
        limitOfPurchase: entity.limitOfPurchase,
        inscriptionRgNumber: entity.inscriptionRgNumber,
      );

  BSFCustomerEntity toEntity() => BSFCustomerEntity(
    code: code,
    personalizedCode: personalizedCode,
    name: name,
    nameReduced: nameReduced,
    cnpjCpfNumber: cnpjCpfNumber,
    suframaCode: suframaCode,
    limitOfPurchase: limitOfPurchase,
    inscriptionRgNumber: inscriptionRgNumber,
  );
}
