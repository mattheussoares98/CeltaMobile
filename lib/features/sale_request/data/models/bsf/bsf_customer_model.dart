import '../../../../../core/domain/entities/entities.dart';
import 'bsf.dart';

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
    required super.paymentFinalizations,
    required super.paymentConditions,
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
    paymentFinalizations,
    paymentConditions,
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
        paymentFinalizations: json['PaymentFinalizations'] != null
            ? (json['PaymentFinalizations'] as List)
                  .map((x) => BSFPaymentFinalizationModel.fromJson(x))
                  .toList()
            : null,
        paymentConditions: json['PaymentConditions'] != null
            ? (json['PaymentConditions'] as List)
                  .map((x) => BSFPaymentConditionModel.fromJson(x))
                  .toList()
            : null,
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
    'PaymentFinalizations': paymentFinalizations
        ?.map((x) => BSFPaymentFinalizationModel.fromEntity(x).toJson())
        .toList(),
    'PaymentConditions': paymentConditions
        ?.map((x) => BSFPaymentConditionModel.fromEntity(x).toJson())
        .toList(),
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
        paymentFinalizations: entity.paymentFinalizations
            ?.map((x) => BSFPaymentFinalizationModel.fromEntity(x))
            .toList(),
        paymentConditions: entity.paymentConditions
            ?.map((x) => BSFPaymentConditionModel.fromEntity(x))
            .toList(),
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
    paymentFinalizations: paymentFinalizations
        ?.map((x) => BSFPaymentFinalizationModel.fromEntity(x))
        .toList(),
    paymentConditions: paymentConditions
        ?.map((x) => BSFPaymentConditionModel.fromEntity(x))
        .toList(),
  );
}
