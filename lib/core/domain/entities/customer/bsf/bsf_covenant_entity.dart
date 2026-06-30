import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:celta_inventario/core/domain/entities/entities.dart';

class BsfCovenantEntity extends Equatable
    implements SelectableItem<BsfCovenantEntity> {
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

  // Customer-Covenant link specific fields
  final int? customerCode;
  final double? limitOfPurchase;
  final String? matriculate;
  final DateTime? dismissalDate;
  final bool? isFired;
  final BSFAddressEntity? billingAddress;
  final BSFAddressEntity? customerDeliveryAddress;
  final BSFAddressEntity? customerCollectAddress;

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
    this.customerCode,
    this.limitOfPurchase,
    this.matriculate,
    this.dismissalDate,
    this.isFired,
    this.billingAddress,
    this.customerDeliveryAddress,
    this.customerCollectAddress,
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
    customerCode,
    limitOfPurchase,
    matriculate,
    dismissalDate,
    isFired,
    billingAddress,
    customerDeliveryAddress,
    customerCollectAddress,
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
    int? customerCode,
    double? limitOfPurchase,
    String? matriculate,
    DateTime? dismissalDate,
    bool? isFired,
    BSFAddressEntity? billingAddress,
    BSFAddressEntity? customerDeliveryAddress,
    BSFAddressEntity? customerCollectAddress,
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
      customerCode: customerCode ?? this.customerCode,
      limitOfPurchase: limitOfPurchase ?? this.limitOfPurchase,
      matriculate: matriculate ?? this.matriculate,
      dismissalDate: dismissalDate ?? this.dismissalDate,
      isFired: isFired ?? this.isFired,
      billingAddress: billingAddress ?? this.billingAddress,
      customerDeliveryAddress: customerDeliveryAddress ?? this.customerDeliveryAddress,
      customerCollectAddress: customerCollectAddress ?? this.customerCollectAddress,
    );
  }

  @override
  BsfCovenantEntity get value => this;

  @override
  Color? get color => null;
}
