import '../../../../../core/domain/entities/entities.dart';
import '../../models.dart';

class BSFCustomerModel extends BSFCustomerEntity {
  const BSFCustomerModel({
    required super.code,
    required super.personalizedCode,
    required super.covenantCode,
    required super.name,
    required super.nameReduced,
    required super.cnpjCpfNumber,
    required super.suframaCode,
    required super.limitOfPurchase,
    required super.inscriptionRgNumber,
    required super.paymentFinalizations,
    required super.paymentConditions,
    required super.saleBlockade,
    required super.saleBlockadeInstruction,
    required super.covenants,
  });

  @override
  List<Object?> get props => [
    personalizedCode,
    covenantCode,
    name,
    nameReduced,
    cnpjCpfNumber,
    suframaCode,
    limitOfPurchase,
    inscriptionRgNumber,
    paymentFinalizations,
    paymentConditions,
    saleBlockade,
    saleBlockadeInstruction,
    covenants,
  ];

  factory BSFCustomerModel.fromJson(Map<String, dynamic> json) =>
      BSFCustomerModel(
        code: json['Code'],
        personalizedCode: json['PersonalizedCode'],
        covenantCode: json['CovenantCode'],
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
        saleBlockade: json['SaleBlockade'] != null
            ? BsfSaleBlockadeModel.fromJson(json['SaleBlockade'])
            : null,
        saleBlockadeInstruction: json['SaleBlockadeInstruction'] != null
            ? BsfSaleBlockadeInstructionModel.fromJson(
                json['SaleBlockadeInstruction'],
              )
            : null,
        covenants: (json['Extensions']?['Covenants'] as List?)
            ?.map(
              (e) => BsfCovenantModel.fromJson(
                e['Covenant'] as Map<String, dynamic>,
              ),
            )
            .toList(),
      );

  Map<String, dynamic> toJson() => {
    'Code': code,
    'PersonalizedCode': personalizedCode,
    'CovenantCode': covenantCode,
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
    'SaleBlockade': saleBlockade != null
        ? BsfSaleBlockadeModel.fromEntity(saleBlockade!).toJson()
        : null,
    'SaleBlockadeInstruction': saleBlockadeInstruction != null
        ? BsfSaleBlockadeInstructionModel.fromEntity(
            saleBlockadeInstruction!,
          ).toJson()
        : null,
    'Extensions': {
      'Covenants': covenants
          ?.map((e) => {'Covenant': BsfCovenantModel.fromEntity(e).toJson()})
          .toList(),
    },
  };

  factory BSFCustomerModel.fromEntity(BSFCustomerEntity entity) =>
      BSFCustomerModel(
        code: entity.code,
        personalizedCode: entity.personalizedCode,
        covenantCode: entity.covenantCode,
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
        saleBlockade: entity.saleBlockade != null
            ? BsfSaleBlockadeModel.fromEntity(entity.saleBlockade!)
            : null,
        saleBlockadeInstruction: entity.saleBlockadeInstruction != null
            ? BsfSaleBlockadeInstructionModel.fromEntity(
                entity.saleBlockadeInstruction!,
              )
            : null,
        covenants: entity.covenants
            ?.map((e) => BsfCovenantModel.fromEntity(e))
            .toList(),
      );

  BSFCustomerEntity toEntity() => BSFCustomerEntity(
    code: code,
    personalizedCode: personalizedCode,
    covenantCode: covenantCode,
    name: name,
    nameReduced: nameReduced,
    cnpjCpfNumber: cnpjCpfNumber,
    suframaCode: suframaCode,
    limitOfPurchase: limitOfPurchase,
    inscriptionRgNumber: inscriptionRgNumber,
    paymentFinalizations: paymentFinalizations,
    paymentConditions: paymentConditions,
    saleBlockade: saleBlockade,
    saleBlockadeInstruction: saleBlockadeInstruction,
    covenants: covenants,
  );
}
