import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';

class BsfCovenantModel extends BsfCovenantEntity {
  const BsfCovenantModel({
    required super.code,
    required super.personalizedCode,
    required super.legacyCode,
    required super.name,
    required super.fantasyName,
    required super.cnpjNumber,
    required super.formatedCnpjNumber,
    required super.stateRegistration,
    required super.formatedStateRegistration,
    required super.dateOfCadaster,
    required super.email,
    required super.dateOfBirthContact,
    required super.nameOfContact,
    required super.haveObservations,
    required super.requiredConveneMatriculate,
    required super.allowSaleAdditional,
    required super.address,
    required super.deliveryAddress,
    required super.collectAddress,
    required super.saleBlockade,
    required super.saleBlockadeInstruction,
    super.customerCode,
    super.limitOfPurchase,
    super.matriculate,
    super.dismissalDate,
    super.isFired,
    super.billingAddress,
    super.customerDeliveryAddress,
    super.customerCollectAddress,
  });

  factory BsfCovenantModel.fromJson(Map json) {
    final covenantJson = json['Covenant'] as Map?;
    final targetJson = covenantJson ?? json;

    return BsfCovenantModel(
      code: targetJson['Code'] as int?,
      personalizedCode: targetJson['PersonalizedCode'] as String?,
      legacyCode: targetJson['LegacyCode'] as String?,
      name: targetJson['Name'] as String? ?? '',
      fantasyName: targetJson['FantasyName'] as String?,
      cnpjNumber: targetJson['CnpjNumber'] as String?,
      formatedCnpjNumber: targetJson['FormatedCnpjNumber'] as String?,
      stateRegistration: targetJson['StateRegistration'] as String?,
      formatedStateRegistration:
          targetJson['FormatedStateRegistration'] as String?,
      dateOfCadaster: targetJson['DateOfCadaster'] != null
          ? DateTime.tryParse(targetJson['DateOfCadaster'] as String)
          : null,
      email: targetJson['Email'] as String?,
      dateOfBirthContact: targetJson['DateOfBirthContact'] != null
          ? DateTime.tryParse(targetJson['DateOfBirthContact'] as String)
          : null,
      nameOfContact: targetJson['NameOfContact'] as String?,
      haveObservations: targetJson['HaveObservations'] as bool?,
      requiredConveneMatriculate:
          targetJson['RequiredConveneMatriculate'] as bool?,
      allowSaleAdditional: targetJson['AllowSaleAdditional'] as bool?,
      address: targetJson['Address'] != null
          ? BSFAddressModel.fromJson(targetJson['Address'] as Map)
          : null,
      deliveryAddress: targetJson['DeliveryAddress'] != null
          ? BSFAddressModel.fromJson(targetJson['DeliveryAddress'] as Map)
          : null,
      collectAddress: targetJson['CollectAddress'] != null
          ? BSFAddressModel.fromJson(targetJson['CollectAddress'] as Map)
          : null,
      saleBlockade: targetJson['SaleBlockade'] != null
          ? BsfSaleBlockadeModel.fromJson(targetJson['SaleBlockade'] as Map)
          : null,
      saleBlockadeInstruction: targetJson['SaleBlockadeInstruction'] != null
          ? BsfSaleBlockadeInstructionModel.fromJson(
              targetJson['SaleBlockadeInstruction'] as Map,
            )
          : null,
      customerCode: covenantJson != null ? json['Code'] as int? : null,
      limitOfPurchase: (json['LimitOfPurchase'] as num?)?.toDouble(),
      matriculate: json['Matriculate'] as String?,
      dismissalDate: json['DismissalDate'] != null
          ? DateTime.tryParse(json['DismissalDate'] as String)
          : null,
      isFired: json['IsFired'] as bool?,
      billingAddress: json['BillingAddress'] != null
          ? BSFAddressModel.fromJson(json['BillingAddress'] as Map)
          : null,
      customerDeliveryAddress:
          covenantJson != null && json['DeliveryAddress'] != null
          ? BSFAddressModel.fromJson(json['DeliveryAddress'] as Map)
          : null,
      customerCollectAddress:
          covenantJson != null && json['CollectAddress'] != null
          ? BSFAddressModel.fromJson(json['CollectAddress'] as Map)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'Code': code,
    'PersonalizedCode': personalizedCode,
    'LegacyCode': legacyCode,
    'Name': name,
    'FantasyName': fantasyName,
    'CnpjNumber': cnpjNumber,
    'FormatedCnpjNumber': formatedCnpjNumber,
    'StateRegistration': stateRegistration,
    'FormatedStateRegistration': formatedStateRegistration,
    'DateOfCadaster': dateOfCadaster?.toIso8601String(),
    'Email': email,
    'DateOfBirthContact': dateOfBirthContact?.toIso8601String(),
    'NameOfContact': nameOfContact,
    'HaveObservations': haveObservations,
    'RequiredConveneMatriculate': requiredConveneMatriculate,
    'AllowSaleAdditional': allowSaleAdditional,
    'Address': address != null
        ? BSFAddressModel.fromEntity(address!).toJson()
        : null,
    'DeliveryAddress': deliveryAddress != null
        ? BSFAddressModel.fromEntity(deliveryAddress!).toJson()
        : null,
    'CollectAddress': collectAddress != null
        ? BSFAddressModel.fromEntity(collectAddress!).toJson()
        : null,
    'SaleBlockade': saleBlockade != null
        ? BsfSaleBlockadeModel.fromEntity(saleBlockade!).toJson()
        : null,
    'SaleBlockadeInstruction': saleBlockadeInstruction != null
        ? BsfSaleBlockadeInstructionModel.fromEntity(
            saleBlockadeInstruction!,
          ).toJson()
        : null,
    'CustomerCode': customerCode,
    'LimitOfPurchase': limitOfPurchase,
    'Matriculate': matriculate,
    'DismissalDate': dismissalDate?.toIso8601String(),
    'IsFired': isFired,
    'BillingAddress': billingAddress != null
        ? BSFAddressModel.fromEntity(billingAddress!).toJson()
        : null,
    'CustomerDeliveryAddress': customerDeliveryAddress != null
        ? BSFAddressModel.fromEntity(customerDeliveryAddress!).toJson()
        : null,
    'CustomerCollectAddress': customerCollectAddress != null
        ? BSFAddressModel.fromEntity(customerCollectAddress!).toJson()
        : null,
  };

  factory BsfCovenantModel.fromEntity(BsfCovenantEntity entity) =>
      BsfCovenantModel(
        code: entity.code,
        personalizedCode: entity.personalizedCode,
        legacyCode: entity.legacyCode,
        name: entity.name,
        fantasyName: entity.fantasyName,
        cnpjNumber: entity.cnpjNumber,
        formatedCnpjNumber: entity.formatedCnpjNumber,
        stateRegistration: entity.stateRegistration,
        formatedStateRegistration: entity.formatedStateRegistration,
        dateOfCadaster: entity.dateOfCadaster,
        email: entity.email,
        dateOfBirthContact: entity.dateOfBirthContact,
        nameOfContact: entity.nameOfContact,
        haveObservations: entity.haveObservations,
        requiredConveneMatriculate: entity.requiredConveneMatriculate,
        allowSaleAdditional: entity.allowSaleAdditional,
        address: entity.address != null
            ? BSFAddressModel.fromEntity(entity.address!)
            : null,
        deliveryAddress: entity.deliveryAddress != null
            ? BSFAddressModel.fromEntity(entity.deliveryAddress!)
            : null,
        collectAddress: entity.collectAddress != null
            ? BSFAddressModel.fromEntity(entity.collectAddress!)
            : null,
        saleBlockade: entity.saleBlockade != null
            ? BsfSaleBlockadeModel.fromEntity(entity.saleBlockade!)
            : null,
        saleBlockadeInstruction: entity.saleBlockadeInstruction != null
            ? BsfSaleBlockadeInstructionModel.fromEntity(
                entity.saleBlockadeInstruction!,
              )
            : null,
        customerCode: entity.customerCode,
        limitOfPurchase: entity.limitOfPurchase,
        matriculate: entity.matriculate,
        dismissalDate: entity.dismissalDate,
        isFired: entity.isFired,
        billingAddress: entity.billingAddress != null
            ? BSFAddressModel.fromEntity(entity.billingAddress!)
            : null,
        customerDeliveryAddress: entity.customerDeliveryAddress != null
            ? BSFAddressModel.fromEntity(entity.customerDeliveryAddress!)
            : null,
        customerCollectAddress: entity.customerCollectAddress != null
            ? BSFAddressModel.fromEntity(entity.customerCollectAddress!)
            : null,
      );

  BsfCovenantEntity toEntity() => BsfCovenantEntity(
    code: code,
    personalizedCode: personalizedCode,
    legacyCode: legacyCode,
    name: name,
    fantasyName: fantasyName,
    cnpjNumber: cnpjNumber,
    formatedCnpjNumber: formatedCnpjNumber,
    stateRegistration: stateRegistration,
    formatedStateRegistration: formatedStateRegistration,
    dateOfCadaster: dateOfCadaster,
    email: email,
    dateOfBirthContact: dateOfBirthContact,
    nameOfContact: nameOfContact,
    haveObservations: haveObservations,
    requiredConveneMatriculate: requiredConveneMatriculate,
    allowSaleAdditional: allowSaleAdditional,
    address: address,
    deliveryAddress: deliveryAddress,
    collectAddress: collectAddress,
    saleBlockade: saleBlockade,
    saleBlockadeInstruction: saleBlockadeInstruction,
    customerCode: customerCode,
    limitOfPurchase: limitOfPurchase,
    matriculate: matriculate,
    dismissalDate: dismissalDate,
    isFired: isFired,
    billingAddress: billingAddress,
    customerDeliveryAddress: customerDeliveryAddress,
    customerCollectAddress: customerCollectAddress,
  );
}
