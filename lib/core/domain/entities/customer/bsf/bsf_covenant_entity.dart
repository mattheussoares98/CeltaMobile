import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../entities.dart';

class BsfCovenantEntity extends Equatable implements SelectableItem<BsfCovenantEntity> {
  final int? code;
  final String? personalizedCode;
  final String? legacyCode;
  @override
  final String name;
  final String? fantasyName;
  final String? cnpjNumber;
  final String? formatedCnpjNumber;
  final String? stateRegistration;
  final String? formatedStateRegistration;
  final DateTime? dateOfCadaster;
  final String? email;
  final DateTime? dateOfBirthContact;
  final String? nameOfContact;
  final bool? haveObservations;
  final bool? requiredConveneMatriculate;
  final bool? allowSaleAdditional;
  final BSFAddressEntity? address;
  final BSFAddressEntity? deliveryAddress;
  final BSFAddressEntity? collectAddress;
  final BsfSaleBlockadeEntity? saleBlockade;
  final BsfSaleBlockadeInstructionEntity? saleBlockadeInstruction;

  const BsfCovenantEntity({
    required this.code,
    required this.personalizedCode,
    required this.legacyCode,
    required this.name,
    required this.fantasyName,
    required this.cnpjNumber,
    required this.formatedCnpjNumber,
    required this.stateRegistration,
    required this.formatedStateRegistration,
    required this.dateOfCadaster,
    required this.email,
    required this.dateOfBirthContact,
    required this.nameOfContact,
    required this.haveObservations,
    required this.requiredConveneMatriculate,
    required this.allowSaleAdditional,
    required this.address,
    required this.deliveryAddress,
    required this.collectAddress,
    required this.saleBlockade,
    required this.saleBlockadeInstruction,
  });

  @override
  List<Object?> get props => [
    code,
    personalizedCode,
    legacyCode,
    name,
    fantasyName,
    cnpjNumber,
    formatedCnpjNumber,
    stateRegistration,
    formatedStateRegistration,
    dateOfCadaster,
    email,
    dateOfBirthContact,
    nameOfContact,
    haveObservations,
    requiredConveneMatriculate,
    allowSaleAdditional,
    address,
    deliveryAddress,
    collectAddress,
    saleBlockade,
    saleBlockadeInstruction,
  ];

  BsfCovenantEntity copyWith({
    int? code,
    String? personalizedCode,
    String? legacyCode,
    String? name,
    String? fantasyName,
    String? cnpjNumber,
    String? formatedCnpjNumber,
    String? stateRegistration,
    String? formatedStateRegistration,
    DateTime? dateOfCadaster,
    String? email,
    DateTime? dateOfBirthContact,
    String? nameOfContact,
    bool? haveObservations,
    bool? requiredConveneMatriculate,
    bool? allowSaleAdditional,
    BSFAddressEntity? address,
    BSFAddressEntity? deliveryAddress,
    BSFAddressEntity? collectAddress,
    BsfSaleBlockadeEntity? saleBlockade,
    BsfSaleBlockadeInstructionEntity? saleBlockadeInstruction,
  }) {
    return BsfCovenantEntity(
      code: code ?? this.code,
      personalizedCode: personalizedCode ?? this.personalizedCode,
      legacyCode: legacyCode ?? this.legacyCode,
      name: name ?? this.name,
      fantasyName: fantasyName ?? this.fantasyName,
      cnpjNumber: cnpjNumber ?? this.cnpjNumber,
      formatedCnpjNumber: formatedCnpjNumber ?? this.formatedCnpjNumber,
      stateRegistration: stateRegistration ?? this.stateRegistration,
      formatedStateRegistration:
          formatedStateRegistration ?? this.formatedStateRegistration,
      dateOfCadaster: dateOfCadaster ?? this.dateOfCadaster,
      email: email ?? this.email,
      dateOfBirthContact: dateOfBirthContact ?? this.dateOfBirthContact,
      nameOfContact: nameOfContact ?? this.nameOfContact,
      haveObservations: haveObservations ?? this.haveObservations,
      requiredConveneMatriculate:
          requiredConveneMatriculate ?? this.requiredConveneMatriculate,
      allowSaleAdditional: allowSaleAdditional ?? this.allowSaleAdditional,
      address: address ?? this.address,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      collectAddress: collectAddress ?? this.collectAddress,
      saleBlockade: saleBlockade ?? this.saleBlockade,
      saleBlockadeInstruction:
          saleBlockadeInstruction ?? this.saleBlockadeInstruction,
    );
  }

  @override
  BsfCovenantEntity get value => this;

  @override
  Color? get color => null;
}

