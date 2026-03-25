import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';
import 'bsf.dart';

class BSFDeliveryAddressModel extends Equatable {
  final int? code;
  final String? zip;
  final String? sash;
  final String? address;
  final String? number;
  final String? complement;
  final String? district;
  final String? reference;
  final bool? mainAddress;
  final bool? defaultDeliveryAddress;
  final bool? defaultCollectAddress;
  final bool? addressContainsNumber;
  final bool? addressIsInAreaOfDeliveryRestriction;
  final String? inscriptionNumber;
  final BSFCountryModel? country;
  final BSFStateModel? state;
  final int? addressType;

  const BSFDeliveryAddressModel({
    required this.code,
    required this.zip,
    required this.sash,
    required this.address,
    required this.number,
    required this.complement,
    required this.district,
    required this.reference,
    required this.mainAddress,
    required this.defaultDeliveryAddress,
    required this.defaultCollectAddress,
    required this.addressContainsNumber,
    required this.addressIsInAreaOfDeliveryRestriction,
    required this.inscriptionNumber,
    required this.country,
    required this.state,
    required this.addressType,
  });

  @override
  List<Object?> get props => [
    code,
    zip,
    sash,
    address,
    number,
    complement,
    district,
    reference,
    mainAddress,
    defaultDeliveryAddress,
    defaultCollectAddress,
    addressContainsNumber,
    addressIsInAreaOfDeliveryRestriction,
    inscriptionNumber,
    country,
    state,
    addressType,
  ];

  factory BSFDeliveryAddressModel.fromJson(Map<String, dynamic> json) =>
      BSFDeliveryAddressModel(
        code: json['Code'],
        zip: json['Zip'],
        sash: json['Sash'],
        address: json['Address'],
        number: json['Number'],
        complement: json['Complement'],
        district: json['District'],
        reference: json['Reference'],
        mainAddress: json['MainAddress'],
        defaultDeliveryAddress: json['DefaultDeliveryAddress'],
        defaultCollectAddress: json['DefaultCollectAddress'],
        addressContainsNumber: json['AddressContainsNumber'],
        addressIsInAreaOfDeliveryRestriction:
            json['AddressIsInAreaOfDeliveryRestriction'],
        inscriptionNumber: json['InscriptionNumber'],
        country: json['Country'] != null
            ? BSFCountryModel.fromJson(json['Country'])
            : null,
        state: json['State'] != null
            ? BSFStateModel.fromJson(json['State'])
            : null,
        addressType: json['AddressType'],
      );

  Map<String, dynamic> toJson() => {
    'Code': code,
    'Zip': zip,
    'Sash': sash,
    'Address': address,
    'Number': number,
    'Complement': complement,
    'District': district,
    'Reference': reference,
    'MainAddress': mainAddress,
    'DefaultDeliveryAddress': defaultDeliveryAddress,
    'DefaultCollectAddress': defaultCollectAddress,
    'AddressContainsNumber': addressContainsNumber,
    'AddressIsInAreaOfDeliveryRestriction':
        addressIsInAreaOfDeliveryRestriction,
    'InscriptionNumber': inscriptionNumber,
    'Country': country?.toJson(),
    'State': state?.toJson(),
    'AddressType': addressType,
  };

  factory BSFDeliveryAddressModel.fromEntity(BSFDeliveryAddressEntity entity) =>
      BSFDeliveryAddressModel(
        code: entity.code,
        zip: entity.zip,
        sash: entity.sash,
        address: entity.address,
        number: entity.number,
        complement: entity.complement,
        district: entity.district,
        reference: entity.reference,
        mainAddress: entity.mainAddress,
        defaultDeliveryAddress: entity.defaultDeliveryAddress,
        defaultCollectAddress: entity.defaultCollectAddress,
        addressContainsNumber: entity.addressContainsNumber,
        addressIsInAreaOfDeliveryRestriction:
            entity.addressIsInAreaOfDeliveryRestriction,
        inscriptionNumber: entity.inscriptionNumber,
        country: entity.country == null
            ? null
            : BSFCountryModel.fromEntity(entity.country!),
        state: entity.state == null
            ? null
            : BSFStateModel.fromEntity(entity.state!),
        addressType: entity.addressType,
      );

  BSFDeliveryAddressEntity toEntity() => BSFDeliveryAddressEntity(
    code: code,
    zip: zip,
    sash: sash,
    address: address,
    number: number,
    complement: complement,
    district: district,
    reference: reference,
    mainAddress: mainAddress,
    defaultDeliveryAddress: defaultDeliveryAddress,
    defaultCollectAddress: defaultCollectAddress,
    addressContainsNumber: addressContainsNumber,
    addressIsInAreaOfDeliveryRestriction: addressIsInAreaOfDeliveryRestriction,
    inscriptionNumber: inscriptionNumber,
    country: country?.toEntity(),
    state: state?.toEntity(),
    addressType: addressType,
  );
}
