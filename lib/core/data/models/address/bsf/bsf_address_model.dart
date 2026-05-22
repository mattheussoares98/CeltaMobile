import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/data/models/address/bsf/bsf.dart';

class BSFAddressModel extends BSFAddressEntity {
  const BSFAddressModel({
    required super.code,
    required super.zip,
    required super.sash,
    required super.address,
    required super.number,
    required super.complement,
    required super.district,
    required super.reference,
    required super.mainAddress,
    required super.defaultDeliveryAddress,
    required super.defaultCollectAddress,
    required super.addressContainsNumber,
    required super.addressIsInAreaOfDeliveryRestriction,
    required super.inscriptionNumber,
    required super.country,
    required super.state,
    required super.addressType,
  });

  factory BSFAddressModel.fromJson(Map<String, dynamic> json) =>
      BSFAddressModel(
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
    'Country': country != null
        ? BSFCountryModel.fromEntity(country!).toJson()
        : null,
    'State': state != null ? BSFStateModel.fromEntity(state!).toJson() : null,
    'AddressType': addressType,
  };

  factory BSFAddressModel.fromEntity(BSFAddressEntity entity) =>
      BSFAddressModel(
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
        country: entity.country != null
            ? BSFCountryModel.fromEntity(entity.country!)
            : null,
        state: entity.state != null
            ? BSFStateModel.fromEntity(entity.state!)
            : null,
        addressType: entity.addressType,
      );

  BSFAddressEntity toEntity() => BSFAddressEntity(
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
    country: (country as BSFCountryModel?)?.toEntity(),
    state: (state as BSFStateModel?)?.toEntity(),
    addressType: addressType,
  );
}
