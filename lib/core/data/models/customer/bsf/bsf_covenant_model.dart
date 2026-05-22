import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/data/models/models.dart';

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
  });

  factory BsfCovenantModel.fromJson(Map<String, dynamic> json) =>
      BsfCovenantModel(
        code: json['Code'] as int?,
        personalizedCode: json['PersonalizedCode'] as String?,
        legacyCode: json['LegacyCode'] as String?,
        name: json['Name'] as String? ?? '',
        fantasyName: json['FantasyName'] as String?,
        cnpjNumber: json['CnpjNumber'] as String?,
        formatedCnpjNumber: json['FormatedCnpjNumber'] as String?,
        stateRegistration: json['StateRegistration'] as String?,
        formatedStateRegistration: json['FormatedStateRegistration'] as String?,
        dateOfCadaster: json['DateOfCadaster'] != null
            ? DateTime.tryParse(json['DateOfCadaster'] as String)
            : null,
        email: json['Email'] as String?,
        dateOfBirthContact: json['DateOfBirthContact'] != null
            ? DateTime.tryParse(json['DateOfBirthContact'] as String)
            : null,
        nameOfContact: json['NameOfContact'] as String?,
        haveObservations: json['HaveObservations'] as bool?,
        requiredConveneMatriculate: json['RequiredConveneMatriculate'] as bool?,
        allowSaleAdditional: json['AllowSaleAdditional'] as bool?,
        address: json['Address'] != null
            ? BSFAddressModel.fromJson(json['Address'] as Map<String, dynamic>)
            : null,
        deliveryAddress: json['DeliveryAddress'] != null
            ? BSFAddressModel.fromJson(
                json['DeliveryAddress'] as Map<String, dynamic>,
              )
            : null,
        collectAddress: json['CollectAddress'] != null
            ? BSFAddressModel.fromJson(
                json['CollectAddress'] as Map<String, dynamic>,
              )
            : null,
        saleBlockade: json['SaleBlockade'] != null
            ? BsfSaleBlockadeModel.fromJson(
                json['SaleBlockade'] as Map<String, dynamic>,
              )
            : null,
        saleBlockadeInstruction: json['SaleBlockadeInstruction'] != null
            ? BsfSaleBlockadeInstructionModel.fromJson(
                json['SaleBlockadeInstruction'] as Map<String, dynamic>,
              )
            : null,
      );

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
  );
}
