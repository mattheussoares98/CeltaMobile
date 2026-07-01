import 'package:equatable/equatable.dart';

import 'package:celta_inventario/core/domain/entities/address/bsf/bsf.dart';

class BSFAddressEntity extends Equatable {
  final int? code;
  final String? zip;
  final String? formetedZip;
  final String? sash;
  final String? address;
  final String? addressWithNumber;
  final String? addressWithNumberAndComplement;
  final String? addressWithNumberDistrictAndComplement;
  final String? addressWithNumberComplementDistrictCityZipState;
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
  final BSFCityEntity? city;
  final BSFCountryEntity? country;
  final String? cityString;
  final BSFStateEntity? state;
  final String? stateString;
  final int? addressType;

  const BSFAddressEntity({
    required this.code,
    required this.zip,
    this.formetedZip,
    required this.sash,
    required this.address,
    this.addressWithNumber,
    this.addressWithNumberAndComplement,
    this.addressWithNumberDistrictAndComplement,
    this.addressWithNumberComplementDistrictCityZipState,
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
    this.city,
    required this.country,
    this.cityString,
    required this.state,
    this.stateString,
    required this.addressType,
  });

  @override
  List<Object?> get props => [
        code,
        zip,
        formetedZip,
        sash,
        address,
        addressWithNumber,
        addressWithNumberAndComplement,
        addressWithNumberDistrictAndComplement,
        addressWithNumberComplementDistrictCityZipState,
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
        city,
        country,
        cityString,
        state,
        stateString,
        addressType,
      ];
}
