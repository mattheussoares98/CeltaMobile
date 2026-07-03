import 'package:celta_inventario/core/data/models/address/bsf/bsf.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';

class BSFAddressModel extends BSFAddressEntity {
  const BSFAddressModel({
    required super.code,
    required super.zip,
    super.formetedZip,
    required super.sash,
    required super.address,
    super.addressWithNumber,
    super.addressWithNumberAndComplement,
    super.addressWithNumberDistrictAndComplement,
    super.addressWithNumberComplementDistrictCityZipState,
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
    super.city,
    required super.country,
    super.cityString,
    required super.state,
    super.stateString,
    required super.addressType,
  });

  factory BSFAddressModel.fromJson(Map json) => BSFAddressModel(
        code: json['Code'],
        zip: json['Zip'],
        formetedZip: json['FormetedZip'],
        sash: json['Sash'],
        address: json['Address'],
        addressWithNumber: json['AddressWithNumber'],
        addressWithNumberAndComplement: json['AddressWithNumberAndComplement'],
        addressWithNumberDistrictAndComplement:
            json['AddressWithNumberDistrictAndComplement'],
        addressWithNumberComplementDistrictCityZipState:
            json['AddressWithNumberComplementDistrictCityZipState'],
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
        city: json['City'] != null
            ? BSFCityModel.fromJson(json['City'])
            : null,
        country: json['Country'] != null
            ? BSFCountryModel.fromJson(json['Country'])
            : null,
        cityString: json['CityString'],
        state: json['State'] != null
            ? BSFStateModel.fromJson(json['State'])
            : null,
        stateString: json['StateString'],
        addressType: json['AddressType'],
      );

  Map<String, dynamic> toJson() => {
        'Code': code,
        'Zip': zip,
        'FormetedZip': formetedZip,
        'Sash': sash,
        'Address': address,
        'AddressWithNumber': addressWithNumber,
        'AddressWithNumberAndComplement': addressWithNumberAndComplement,
        'AddressWithNumberDistrictAndComplement':
            addressWithNumberDistrictAndComplement,
        'AddressWithNumberComplementDistrictCityZipState':
            addressWithNumberComplementDistrictCityZipState,
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
        'City': city != null
            ? BSFCityModel.fromEntity(city!).toJson()
            : null,
        'Country': country != null
            ? BSFCountryModel.fromEntity(country!).toJson()
            : null,
        'CityString': cityString,
        'State': state != null ? BSFStateModel.fromEntity(state!).toJson() : null,
        'StateString': stateString,
        'AddressType': addressType,
      };

  factory BSFAddressModel.fromEntity(BSFAddressEntity entity) =>
      BSFAddressModel(
        code: entity.code,
        zip: entity.zip,
        formetedZip: entity.formetedZip,
        sash: entity.sash,
        address: entity.address,
        addressWithNumber: entity.addressWithNumber,
        addressWithNumberAndComplement: entity.addressWithNumberAndComplement,
        addressWithNumberDistrictAndComplement:
            entity.addressWithNumberDistrictAndComplement,
        addressWithNumberComplementDistrictCityZipState:
            entity.addressWithNumberComplementDistrictCityZipState,
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
        city: entity.city != null
            ? BSFCityModel.fromEntity(entity.city!)
            : null,
        country: entity.country != null
            ? BSFCountryModel.fromEntity(entity.country!)
            : null,
        cityString: entity.cityString,
        state: entity.state != null
            ? BSFStateModel.fromEntity(entity.state!)
            : null,
        stateString: entity.stateString,
        addressType: entity.addressType,
      );

  BSFAddressEntity toEntity() => BSFAddressEntity(
        code: code,
        zip: zip,
        formetedZip: formetedZip,
        sash: sash,
        address: address,
        addressWithNumber: addressWithNumber,
        addressWithNumberAndComplement: addressWithNumberAndComplement,
        addressWithNumberDistrictAndComplement:
            addressWithNumberDistrictAndComplement,
        addressWithNumberComplementDistrictCityZipState:
            addressWithNumberComplementDistrictCityZipState,
        number: number,
        complement: complement,
        district: district,
        reference: reference,
        mainAddress: mainAddress,
        defaultDeliveryAddress: defaultDeliveryAddress,
        defaultCollectAddress: defaultCollectAddress,
        addressContainsNumber: addressContainsNumber,
        addressIsInAreaOfDeliveryRestriction:
            addressIsInAreaOfDeliveryRestriction,
        inscriptionNumber: inscriptionNumber,
        city: (city as BSFCityModel?)?.toEntity(),
        country: (country as BSFCountryModel?)?.toEntity(),
        cityString: cityString,
        state: (state as BSFStateModel?)?.toEntity(),
        stateString: stateString,
        addressType: addressType,
      );
}
